import numpy
from gws import GWS

def somefunc():
    input_dict = {}

    input_dict["object_com"] = [0, 0, 0]

    input_dict["frictions"] = [0.5,0.5,0.5,0.5,0.5]
    input_dict["contacts"] = [[-0.04275289922952652, 0.0005646370118483901, 0.22441600263118744, -0.9403190016746521, -0.3392289876937866,0.026886099949479103],
                [-0.030062099918723106,0.03821209818124771,0.23833100497722626,-0.6411030292510986,0.7499759793281555,0.1628579944372177],
                [0.030443299561738968,0.02221529930830002,0.19432200491428375,0.9299020171165466,0.3666580021381378,0.02906000055372715],
                [-0.006476739887148142,-0.02706810086965561,0.2183780074119568,-0.0,-1.0,-0.0],
                [0.028938399627804756,-0.0031032399274408817,0.22035899758338928,0.9309200048446655,-0.3553209900856018,0.08446569740772247]]

    input_dict["actuation_matrix"] = numpy.array([[1,0,0,0,0],
                                    [0,1,0,0,0],
                                    [0,0,1,0,0],
                                    [0,0,0,1,0],
                                    [0,0,0,0,1]])

    input_dict["normal_forces"] = [3.0,3.0,3.0,3.0,3.0]

    input_dict["cone_discretization_factors"] = [3,3,3,3,3]

    input_dict["method_list"] =  ["minkowski"]

    output_dict = GWS(input_dict)
    print(output_dict)
    return input_dict