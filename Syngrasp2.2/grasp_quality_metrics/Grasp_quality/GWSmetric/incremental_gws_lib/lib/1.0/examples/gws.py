# -*- coding: utf-8 -*-
"""
Created on Tue Jan 21 13:32:59 2016

@author: Ashok Meenakshi Sundaram
"""

import os
cur_dir = os.path.dirname(os.path.abspath(__file__))

import sys
# library path to icremental_gws_calculation.so
# replace this path based on where you save the incremental_gws_calculation.so (or) export the location to the PYTHONPATH variable
LIBRARY_PATH = cur_dir + '/../x86_64/'
sys.path.append(LIBRARY_PATH)

import incremental_gws_calculation
import numpy


def GWS(input_dict):
    # center of mass of the object in 3D
    object_com = input_dict["object_com"]

    # friction coefficient at each grasp contact
    # size of this list should be equal to the number of grasp contacts
    # in this case, there are five friction coefficients of 0.5
    frictions = input_dict["frictions"]

    # grasp contacts, add new rows for each new contact
    # for each grasp contact, first three refer to the contact position in 3D, last three refer to the contact surface normals in 3D
    # in this case, there are five contacts
    contacts = input_dict["contacts"]

    # actuation matrix defining which contacts map to which actuator
    # size of the matrix is rows: number of actuators ; columns: number of contacts
    # identity matrix denote all contacts are fully actuated
    # for example, consider four contacts with three actuators
    # where first and fourth contact are with actuator 1, second contact is with actuator 2, and third contact is with actuator 3
    # then, the actuation matrix will be([[1,0,0,1],
    #                                     [0,1,0,0],
    #                                     [0,0,1,0]])
    # in this case, consider a fully actuated scenario (5 actuators with 5 contacts)
    # the act   uation matrix is an identity matrix of size 5x5
    actuation_matrix = input_dict["actuation_matrix"]

    # forces that can be applied at each grasp contact
    # size of this list should be equal to the number of grasp contacts
    # in this case, there are five normal forces of 3N
    normal_forces = input_dict["normal_forces"]

    # initial number of primitive wrenches to be considered on the friction cone at each grasp contact
    # size of this list should be equal to the number of grasp contacts
    # 3 primitive wrenches per contact suits better because if there are more primitive wrenches initially,
    # more wrenches get added in the iterative process (currenlty 5 iterations)
    # and their Minkowski sum might result in a huge number of wrenches that the Qhull library can not handle
    # in this case, there are five friction cone discretization factor of 3
    cone_discretization_factors = input_dict["cone_discretization_factors"]

    # defines if plots (grasp force space, grasp torque space, object primitive forces, object primitive torques) have to be generated
    # True (or) False
    # in this case of True, plots are shown
    # depending on your matplotlib backend configuration in matplotlibrc file, if all the dependencies were not found for that particular
    # backend, the plot windows may not show up
    # in some cases the plot window might also close immediately - this requires a fix in the future
    create_plots = False

    # log output level
    # 0: do not output any statements
    # 10: output INFO and DEBUG statements
    # 20: output only INFO statements
    # debug statements show the theta on the contact friction cone base at which the new primitive wrench maximizes the hull in the weakest direction
    # in this case of 20 only info statements are printed
    log_level = 0

    # create and initialize the object of the class IncrementalGWSCalculation provided by the module incremental_gws_calculation
    # make sure to pass all the constructor variables appropriately
    igws = incremental_gws_calculation.IncrementalGWSCalculation(object_com = object_com,
                                                                contact_frictions = frictions,
                                                                contact_points = contacts,
                                                                contact_actuation_matrix = actuation_matrix,
                                                                contact_normal_forces = normal_forces,
                                                                contact_cone_discritizations_factors = cone_discretization_factors,
                                                                show_plots = create_plots,
                                                                logger_level = log_level)
    quality_dict = {} # Dict initialization 
    method_list = input_dict["method_list"]

    for method in method_list:
    # largest minimum resisted wrench based on the GWS constructed from the union of the contact wrenches and the total time taken
    # in the case of non force closure grasp, the quality is returned as 0.0
        if method == "union":
            grasp_quality_1, time_1 = igws.calculate_union_gws()
            quality_dict["union"] = grasp_quality_1

    # largest minimum resisted wrench based on the GWS constructed from the minkowski sum of the contact wrenches and the total time taken
    # in the case of non force closure grasp, the quality is returned as 0.0
        if method == "minkowski":
            grasp_quality_2, time_2 = igws.calculate_minkowski_gws()
            quality_dict["minkowski"] = grasp_quality_2
    # largest minimum resisted wrench based on the GWS constructed incrementally from the union of the contact wrenches and the total time taken
        # in the case of non force closure grasp, the quality is returned as 0.0
        if method == "Inc_union":
            grasp_quality_3, time_3 = igws.calculate_union_incremental_gws()
            quality_dict["Inc_union"] = grasp_quality_3

        # largest minimum resisted wrench based on the GWS constructed incrementally from the minkowski sum of the contact wrenches and the total time taken
        # in the case of non force closure grasp, the quality is returned as 0.0
        if method == "Inc_minkowski":
            grasp_quality_4, time_4 = igws.calculate_minkowski_incremental_gws()
            quality_dict["Inc_minkowski"] = grasp_quality_4

        
    
    return quality_dict
'''
    P.S:

    With just three initial primitive wrenches and GWS constructed incrementally from the Minkowski sum of the wrenches,
    a quality approximately equivalent to that of the one computed from a pure Minkowski GWS with eight primitive wrenches
    can be achieved in almost half the time.
'''