/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 4.0.2
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package org.opensim.modeling;

/**
 * ActuatorPowerProbe is a ModelComponent Probe for computing an operation on a<br>
 * actuator power or sum of actuator powers in the model during a simulation.<br>
 * E.g. Actuator work is the integral of actuator power with respect to time, so by using the<br>
 * ActuatorPowerProbe with the 'integrate' operation, Actuator work may be computed.<br>
 * <br>
 * @author Tim Dorn
 */
public class ActuatorPowerProbe extends Probe {
  private transient long swigCPtr;

  public ActuatorPowerProbe(long cPtr, boolean cMemoryOwn) {
    super(opensimSimulationJNI.ActuatorPowerProbe_SWIGUpcast(cPtr), cMemoryOwn);
    swigCPtr = cPtr;
  }

  public static long getCPtr(ActuatorPowerProbe obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  @SuppressWarnings("deprecation")
  protected void finalize() {
    delete();
  }

  public synchronized void delete() {
    if (swigCPtr != 0) {
      if (swigCMemOwn) {
        swigCMemOwn = false;
        opensimSimulationJNI.delete_ActuatorPowerProbe(swigCPtr);
      }
      swigCPtr = 0;
    }
    super.delete();
  }

  public static ActuatorPowerProbe safeDownCast(OpenSimObject obj) {
    long cPtr = opensimSimulationJNI.ActuatorPowerProbe_safeDownCast(OpenSimObject.getCPtr(obj), obj);
    return (cPtr == 0) ? null : new ActuatorPowerProbe(cPtr, false);
  }

  public void assign(OpenSimObject aObject) {
    opensimSimulationJNI.ActuatorPowerProbe_assign(swigCPtr, this, OpenSimObject.getCPtr(aObject), aObject);
  }

  public static String getClassName() {
    return opensimSimulationJNI.ActuatorPowerProbe_getClassName();
  }

  public OpenSimObject clone() {
    long cPtr = opensimSimulationJNI.ActuatorPowerProbe_clone(swigCPtr, this);
    return (cPtr == 0) ? null : new ActuatorPowerProbe(cPtr, true);
  }

  public String getConcreteClassName() {
    return opensimSimulationJNI.ActuatorPowerProbe_getConcreteClassName(swigCPtr, this);
  }

  /**
   *  List of Actuators to probe.  *
   */
  public void copyProperty_actuator_names(ActuatorPowerProbe source) {
    opensimSimulationJNI.ActuatorPowerProbe_copyProperty_actuator_names(swigCPtr, this, ActuatorPowerProbe.getCPtr(source), source);
  }

  public String get_actuator_names(int i) {
    return opensimSimulationJNI.ActuatorPowerProbe_get_actuator_names(swigCPtr, this, i);
  }

  public SWIGTYPE_p_std__string upd_actuator_names(int i) {
    return new SWIGTYPE_p_std__string(opensimSimulationJNI.ActuatorPowerProbe_upd_actuator_names(swigCPtr, this, i), false);
  }

  public void set_actuator_names(int i, String value) {
    opensimSimulationJNI.ActuatorPowerProbe_set_actuator_names(swigCPtr, this, i, value);
  }

  public int append_actuator_names(String value) {
    return opensimSimulationJNI.ActuatorPowerProbe_append_actuator_names(swigCPtr, this, value);
  }

  public void constructProperty_actuator_names() {
    opensimSimulationJNI.ActuatorPowerProbe_constructProperty_actuator_names(swigCPtr, this);
  }

  /**
   *  Flag to specify whether to report the sum of all powers,<br>
   *     or report each power value separately.  *
   */
  public void copyProperty_sum_powers_together(ActuatorPowerProbe source) {
    opensimSimulationJNI.ActuatorPowerProbe_copyProperty_sum_powers_together(swigCPtr, this, ActuatorPowerProbe.getCPtr(source), source);
  }

  public boolean get_sum_powers_together(int i) {
    return opensimSimulationJNI.ActuatorPowerProbe_get_sum_powers_together__SWIG_0(swigCPtr, this, i);
  }

  public SWIGTYPE_p_bool upd_sum_powers_together(int i) {
    return new SWIGTYPE_p_bool(opensimSimulationJNI.ActuatorPowerProbe_upd_sum_powers_together__SWIG_0(swigCPtr, this, i), false);
  }

  public void set_sum_powers_together(int i, boolean value) {
    opensimSimulationJNI.ActuatorPowerProbe_set_sum_powers_together__SWIG_0(swigCPtr, this, i, value);
  }

  public int append_sum_powers_together(boolean value) {
    return opensimSimulationJNI.ActuatorPowerProbe_append_sum_powers_together(swigCPtr, this, value);
  }

  public void constructProperty_sum_powers_together(boolean initValue) {
    opensimSimulationJNI.ActuatorPowerProbe_constructProperty_sum_powers_together(swigCPtr, this, initValue);
  }

  public boolean get_sum_powers_together() {
    return opensimSimulationJNI.ActuatorPowerProbe_get_sum_powers_together__SWIG_1(swigCPtr, this);
  }

  public SWIGTYPE_p_bool upd_sum_powers_together() {
    return new SWIGTYPE_p_bool(opensimSimulationJNI.ActuatorPowerProbe_upd_sum_powers_together__SWIG_1(swigCPtr, this), false);
  }

  public void set_sum_powers_together(boolean value) {
    opensimSimulationJNI.ActuatorPowerProbe_set_sum_powers_together__SWIG_1(swigCPtr, this, value);
  }

  /**
   *  Element-wise power exponent to apply to each actuator power prior to<br>
   *     the Probe operation.  For example, if two actuators A1 and A2 are given in<br>
   *     actuator_names, then the Probe value will be equal to Power_A1^exponent +<br>
   *     Power_A2^exponent.
   */
  public void copyProperty_exponent(ActuatorPowerProbe source) {
    opensimSimulationJNI.ActuatorPowerProbe_copyProperty_exponent(swigCPtr, this, ActuatorPowerProbe.getCPtr(source), source);
  }

  public double get_exponent(int i) {
    return opensimSimulationJNI.ActuatorPowerProbe_get_exponent__SWIG_0(swigCPtr, this, i);
  }

  public SWIGTYPE_p_double upd_exponent(int i) {
    return new SWIGTYPE_p_double(opensimSimulationJNI.ActuatorPowerProbe_upd_exponent__SWIG_0(swigCPtr, this, i), false);
  }

  public void set_exponent(int i, double value) {
    opensimSimulationJNI.ActuatorPowerProbe_set_exponent__SWIG_0(swigCPtr, this, i, value);
  }

  public int append_exponent(double value) {
    return opensimSimulationJNI.ActuatorPowerProbe_append_exponent(swigCPtr, this, value);
  }

  public void constructProperty_exponent(double initValue) {
    opensimSimulationJNI.ActuatorPowerProbe_constructProperty_exponent(swigCPtr, this, initValue);
  }

  public double get_exponent() {
    return opensimSimulationJNI.ActuatorPowerProbe_get_exponent__SWIG_1(swigCPtr, this);
  }

  public SWIGTYPE_p_double upd_exponent() {
    return new SWIGTYPE_p_double(opensimSimulationJNI.ActuatorPowerProbe_upd_exponent__SWIG_1(swigCPtr, this), false);
  }

  public void set_exponent(double value) {
    opensimSimulationJNI.ActuatorPowerProbe_set_exponent__SWIG_1(swigCPtr, this, value);
  }

  /**
   *  Default constructor 
   */
  public ActuatorPowerProbe() {
    this(opensimSimulationJNI.new_ActuatorPowerProbe__SWIG_0(), true);
  }

  /**
   *  Convenience constructor 
   */
  public ActuatorPowerProbe(ArrayStr actuator_names, boolean sum_powers_together, double exponent) {
    this(opensimSimulationJNI.new_ActuatorPowerProbe__SWIG_1(ArrayStr.getCPtr(actuator_names), actuator_names, sum_powers_together, exponent), true);
  }

  /**
   *  Returns the names of the Actuators being probed. 
   */
  public PropertyString getActuatorNames() {
    return new PropertyString(opensimSimulationJNI.ActuatorPowerProbe_getActuatorNames(swigCPtr, this), false);
  }

  /**
   *  Returns whether to report sum of all actuator powers together<br>
   *     or report the actuator powers individually. 
   */
  public boolean getSumPowersTogether() {
    return opensimSimulationJNI.ActuatorPowerProbe_getSumPowersTogether(swigCPtr, this);
  }

  /**
   *  Returns the exponent to apply to each actuator power. 
   */
  public double getExponent() {
    return opensimSimulationJNI.ActuatorPowerProbe_getExponent(swigCPtr, this);
  }

  /**
   *  Sets the names of the Actuators being probed. 
   */
  public void setActuatorNames(ArrayStr actuatorNames) {
    opensimSimulationJNI.ActuatorPowerProbe_setActuatorNames(swigCPtr, this, ArrayStr.getCPtr(actuatorNames), actuatorNames);
  }

  /**
   *  Sets whether to report sum of all actuator powers together<br>
   *     or report the actuator powers individually. 
   */
  public void setSumPowersTogether(boolean sum_powers_together) {
    opensimSimulationJNI.ActuatorPowerProbe_setSumPowersTogether(swigCPtr, this, sum_powers_together);
  }

  /**
   *  Sets the exponent to apply to each actuator power. 
   */
  public void setExponent(double exponent) {
    opensimSimulationJNI.ActuatorPowerProbe_setExponent(swigCPtr, this, exponent);
  }

  /**
   *  Compute the Actuator power. 
   */
  public Vector computeProbeInputs(State state) {
    return new Vector(opensimSimulationJNI.ActuatorPowerProbe_computeProbeInputs(swigCPtr, this, State.getCPtr(state), state), true);
  }

  /**
   *  Returns the number of probe inputs in the vector returned by<br>
   * computeProbeInputs(). 
   */
  public int getNumProbeInputs() {
    return opensimSimulationJNI.ActuatorPowerProbe_getNumProbeInputs(swigCPtr, this);
  }

  /**
   *  Returns the column labels of the probe values for reporting.<br>
   *     Currently uses the Probe name as the column label, so be sure<br>
   *     to name your probe appropriately! 
   */
  public ArrayStr getProbeOutputLabels() {
    return new ArrayStr(opensimSimulationJNI.ActuatorPowerProbe_getProbeOutputLabels(swigCPtr, this), true);
  }

  public void extendConnectToModel(Model aModel) {
    opensimSimulationJNI.ActuatorPowerProbe_extendConnectToModel(swigCPtr, this, Model.getCPtr(aModel), aModel);
  }

}
