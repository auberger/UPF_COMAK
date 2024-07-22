/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 4.0.2
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package org.opensim.modeling;

public class COMAKCostFunctionParameter extends OpenSimObject {
  private transient long swigCPtr;

  public COMAKCostFunctionParameter(long cPtr, boolean cMemoryOwn) {
    super(opensimJAMJNI.COMAKCostFunctionParameter_SWIGUpcast(cPtr), cMemoryOwn);
    swigCPtr = cPtr;
  }

  public static long getCPtr(COMAKCostFunctionParameter obj) {
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
        opensimJAMJNI.delete_COMAKCostFunctionParameter(swigCPtr);
      }
      swigCPtr = 0;
    }
    super.delete();
  }

  public static COMAKCostFunctionParameter safeDownCast(OpenSimObject obj) {
    long cPtr = opensimJAMJNI.COMAKCostFunctionParameter_safeDownCast(OpenSimObject.getCPtr(obj), obj);
    return (cPtr == 0) ? null : new COMAKCostFunctionParameter(cPtr, false);
  }

  public void assign(OpenSimObject aObject) {
    opensimJAMJNI.COMAKCostFunctionParameter_assign(swigCPtr, this, OpenSimObject.getCPtr(aObject), aObject);
  }

  public static String getClassName() {
    return opensimJAMJNI.COMAKCostFunctionParameter_getClassName();
  }

  public OpenSimObject clone() {
    long cPtr = opensimJAMJNI.COMAKCostFunctionParameter_clone(swigCPtr, this);
    return (cPtr == 0) ? null : new COMAKCostFunctionParameter(cPtr, true);
  }

  public String getConcreteClassName() {
    return opensimJAMJNI.COMAKCostFunctionParameter_getConcreteClassName(swigCPtr, this);
  }

  public void copyProperty_actuator(COMAKCostFunctionParameter source) {
    opensimJAMJNI.COMAKCostFunctionParameter_copyProperty_actuator(swigCPtr, this, COMAKCostFunctionParameter.getCPtr(source), source);
  }

  public String get_actuator(int i) {
    return opensimJAMJNI.COMAKCostFunctionParameter_get_actuator__SWIG_0(swigCPtr, this, i);
  }

  public SWIGTYPE_p_std__string upd_actuator(int i) {
    return new SWIGTYPE_p_std__string(opensimJAMJNI.COMAKCostFunctionParameter_upd_actuator__SWIG_0(swigCPtr, this, i), false);
  }

  public void set_actuator(int i, String value) {
    opensimJAMJNI.COMAKCostFunctionParameter_set_actuator__SWIG_0(swigCPtr, this, i, value);
  }

  public int append_actuator(String value) {
    return opensimJAMJNI.COMAKCostFunctionParameter_append_actuator(swigCPtr, this, value);
  }

  public void constructProperty_actuator(String initValue) {
    opensimJAMJNI.COMAKCostFunctionParameter_constructProperty_actuator(swigCPtr, this, initValue);
  }

  public String get_actuator() {
    return opensimJAMJNI.COMAKCostFunctionParameter_get_actuator__SWIG_1(swigCPtr, this);
  }

  public SWIGTYPE_p_std__string upd_actuator() {
    return new SWIGTYPE_p_std__string(opensimJAMJNI.COMAKCostFunctionParameter_upd_actuator__SWIG_1(swigCPtr, this), false);
  }

  public void set_actuator(String value) {
    opensimJAMJNI.COMAKCostFunctionParameter_set_actuator__SWIG_1(swigCPtr, this, value);
  }

  public void copyProperty_weight(COMAKCostFunctionParameter source) {
    opensimJAMJNI.COMAKCostFunctionParameter_copyProperty_weight(swigCPtr, this, COMAKCostFunctionParameter.getCPtr(source), source);
  }

  public Function get_weight(int i) {
    return new Function(opensimJAMJNI.COMAKCostFunctionParameter_get_weight__SWIG_0(swigCPtr, this, i), false);
  }

  public Function upd_weight(int i) {
    return new Function(opensimJAMJNI.COMAKCostFunctionParameter_upd_weight__SWIG_0(swigCPtr, this, i), false);
  }

  public void set_weight(int i, Function value) {
    opensimJAMJNI.COMAKCostFunctionParameter_set_weight__SWIG_0(swigCPtr, this, i, Function.getCPtr(value), value);
  }

  public int append_weight(Function value) {
    return opensimJAMJNI.COMAKCostFunctionParameter_append_weight(swigCPtr, this, Function.getCPtr(value), value);
  }

  public void constructProperty_weight(Function initValue) {
    opensimJAMJNI.COMAKCostFunctionParameter_constructProperty_weight(swigCPtr, this, Function.getCPtr(initValue), initValue);
  }

  public Function get_weight() {
    return new Function(opensimJAMJNI.COMAKCostFunctionParameter_get_weight__SWIG_1(swigCPtr, this), false);
  }

  public Function upd_weight() {
    return new Function(opensimJAMJNI.COMAKCostFunctionParameter_upd_weight__SWIG_1(swigCPtr, this), false);
  }

  public void set_weight(Function value) {
    opensimJAMJNI.COMAKCostFunctionParameter_set_weight__SWIG_1(swigCPtr, this, Function.getCPtr(value), value);
  }

  public void copyProperty_desired_activation(COMAKCostFunctionParameter source) {
    opensimJAMJNI.COMAKCostFunctionParameter_copyProperty_desired_activation(swigCPtr, this, COMAKCostFunctionParameter.getCPtr(source), source);
  }

  public Function get_desired_activation(int i) {
    return new Function(opensimJAMJNI.COMAKCostFunctionParameter_get_desired_activation__SWIG_0(swigCPtr, this, i), false);
  }

  public Function upd_desired_activation(int i) {
    return new Function(opensimJAMJNI.COMAKCostFunctionParameter_upd_desired_activation__SWIG_0(swigCPtr, this, i), false);
  }

  public void set_desired_activation(int i, Function value) {
    opensimJAMJNI.COMAKCostFunctionParameter_set_desired_activation__SWIG_0(swigCPtr, this, i, Function.getCPtr(value), value);
  }

  public int append_desired_activation(Function value) {
    return opensimJAMJNI.COMAKCostFunctionParameter_append_desired_activation(swigCPtr, this, Function.getCPtr(value), value);
  }

  public void constructProperty_desired_activation(Function initValue) {
    opensimJAMJNI.COMAKCostFunctionParameter_constructProperty_desired_activation(swigCPtr, this, Function.getCPtr(initValue), initValue);
  }

  public Function get_desired_activation() {
    return new Function(opensimJAMJNI.COMAKCostFunctionParameter_get_desired_activation__SWIG_1(swigCPtr, this), false);
  }

  public Function upd_desired_activation() {
    return new Function(opensimJAMJNI.COMAKCostFunctionParameter_upd_desired_activation__SWIG_1(swigCPtr, this), false);
  }

  public void set_desired_activation(Function value) {
    opensimJAMJNI.COMAKCostFunctionParameter_set_desired_activation__SWIG_1(swigCPtr, this, Function.getCPtr(value), value);
  }

  public void copyProperty_activation_lower_bound(COMAKCostFunctionParameter source) {
    opensimJAMJNI.COMAKCostFunctionParameter_copyProperty_activation_lower_bound(swigCPtr, this, COMAKCostFunctionParameter.getCPtr(source), source);
  }

  public Function get_activation_lower_bound(int i) {
    return new Function(opensimJAMJNI.COMAKCostFunctionParameter_get_activation_lower_bound__SWIG_0(swigCPtr, this, i), false);
  }

  public Function upd_activation_lower_bound(int i) {
    return new Function(opensimJAMJNI.COMAKCostFunctionParameter_upd_activation_lower_bound__SWIG_0(swigCPtr, this, i), false);
  }

  public void set_activation_lower_bound(int i, Function value) {
    opensimJAMJNI.COMAKCostFunctionParameter_set_activation_lower_bound__SWIG_0(swigCPtr, this, i, Function.getCPtr(value), value);
  }

  public int append_activation_lower_bound(Function value) {
    return opensimJAMJNI.COMAKCostFunctionParameter_append_activation_lower_bound(swigCPtr, this, Function.getCPtr(value), value);
  }

  public void constructProperty_activation_lower_bound(Function initValue) {
    opensimJAMJNI.COMAKCostFunctionParameter_constructProperty_activation_lower_bound(swigCPtr, this, Function.getCPtr(initValue), initValue);
  }

  public Function get_activation_lower_bound() {
    return new Function(opensimJAMJNI.COMAKCostFunctionParameter_get_activation_lower_bound__SWIG_1(swigCPtr, this), false);
  }

  public Function upd_activation_lower_bound() {
    return new Function(opensimJAMJNI.COMAKCostFunctionParameter_upd_activation_lower_bound__SWIG_1(swigCPtr, this), false);
  }

  public void set_activation_lower_bound(Function value) {
    opensimJAMJNI.COMAKCostFunctionParameter_set_activation_lower_bound__SWIG_1(swigCPtr, this, Function.getCPtr(value), value);
  }

  public void copyProperty_activation_upper_bound(COMAKCostFunctionParameter source) {
    opensimJAMJNI.COMAKCostFunctionParameter_copyProperty_activation_upper_bound(swigCPtr, this, COMAKCostFunctionParameter.getCPtr(source), source);
  }

  public Function get_activation_upper_bound(int i) {
    return new Function(opensimJAMJNI.COMAKCostFunctionParameter_get_activation_upper_bound__SWIG_0(swigCPtr, this, i), false);
  }

  public Function upd_activation_upper_bound(int i) {
    return new Function(opensimJAMJNI.COMAKCostFunctionParameter_upd_activation_upper_bound__SWIG_0(swigCPtr, this, i), false);
  }

  public void set_activation_upper_bound(int i, Function value) {
    opensimJAMJNI.COMAKCostFunctionParameter_set_activation_upper_bound__SWIG_0(swigCPtr, this, i, Function.getCPtr(value), value);
  }

  public int append_activation_upper_bound(Function value) {
    return opensimJAMJNI.COMAKCostFunctionParameter_append_activation_upper_bound(swigCPtr, this, Function.getCPtr(value), value);
  }

  public void constructProperty_activation_upper_bound(Function initValue) {
    opensimJAMJNI.COMAKCostFunctionParameter_constructProperty_activation_upper_bound(swigCPtr, this, Function.getCPtr(initValue), initValue);
  }

  public Function get_activation_upper_bound() {
    return new Function(opensimJAMJNI.COMAKCostFunctionParameter_get_activation_upper_bound__SWIG_1(swigCPtr, this), false);
  }

  public Function upd_activation_upper_bound() {
    return new Function(opensimJAMJNI.COMAKCostFunctionParameter_upd_activation_upper_bound__SWIG_1(swigCPtr, this), false);
  }

  public void set_activation_upper_bound(Function value) {
    opensimJAMJNI.COMAKCostFunctionParameter_set_activation_upper_bound__SWIG_1(swigCPtr, this, Function.getCPtr(value), value);
  }

  public COMAKCostFunctionParameter() {
    this(opensimJAMJNI.new_COMAKCostFunctionParameter(), true);
  }

  public void constructProperties() {
    opensimJAMJNI.COMAKCostFunctionParameter_constructProperties(swigCPtr, this);
  }

}
