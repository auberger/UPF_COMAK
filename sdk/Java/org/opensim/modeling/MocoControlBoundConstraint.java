/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 4.0.2
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package org.opensim.modeling;

/**
 *  This class constrains any number of control signals from ScalarActautor%s to<br>
 * be between two time-based functions. It is possible to constrain the control<br>
 * signal to be exactly to a provided function; see the equality_with_lower<br>
 * property.<br>
 * <br>
 * If a function is a GCVSpline, we ensure that the spline covers the entire<br>
 * possible time range in the problem (using the problem's time bounds). We do<br>
 * not perform such a check for other types of functions.<br>
 * <br>
 * Note: If you omit the lower and upper bounds, then this class will not<br>
 * constrain any control signals, even if you have provided control paths.<br>
 * <br>
 * Note: This class can only constrain control signals for ScalarActuator%s.<br>
 * 
 */
public class MocoControlBoundConstraint extends MocoPathConstraint {
  private transient long swigCPtr;

  public MocoControlBoundConstraint(long cPtr, boolean cMemoryOwn) {
    super(opensimMocoJNI.MocoControlBoundConstraint_SWIGUpcast(cPtr), cMemoryOwn);
    swigCPtr = cPtr;
  }

  public static long getCPtr(MocoControlBoundConstraint obj) {
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
        opensimMocoJNI.delete_MocoControlBoundConstraint(swigCPtr);
      }
      swigCPtr = 0;
    }
    super.delete();
  }

  public static MocoControlBoundConstraint safeDownCast(OpenSimObject obj) {
    long cPtr = opensimMocoJNI.MocoControlBoundConstraint_safeDownCast(OpenSimObject.getCPtr(obj), obj);
    return (cPtr == 0) ? null : new MocoControlBoundConstraint(cPtr, false);
  }

  public void assign(OpenSimObject aObject) {
    opensimMocoJNI.MocoControlBoundConstraint_assign(swigCPtr, this, OpenSimObject.getCPtr(aObject), aObject);
  }

  public static String getClassName() {
    return opensimMocoJNI.MocoControlBoundConstraint_getClassName();
  }

  public OpenSimObject clone() {
    long cPtr = opensimMocoJNI.MocoControlBoundConstraint_clone(swigCPtr, this);
    return (cPtr == 0) ? null : new MocoControlBoundConstraint(cPtr, true);
  }

  public String getConcreteClassName() {
    return opensimMocoJNI.MocoControlBoundConstraint_getConcreteClassName(swigCPtr, this);
  }

  public MocoControlBoundConstraint() {
    this(opensimMocoJNI.new_MocoControlBoundConstraint(), true);
  }

  /**
   *  Set the control paths (absolute paths to actuators in the model)<br>
   *  constrained by this class.<br>
   *  
   */
  public void addControlPath(String controlPath) {
    opensimMocoJNI.MocoControlBoundConstraint_addControlPath(swigCPtr, this, controlPath);
  }

  public void setControlPaths(StdVectorString controlPaths) {
    opensimMocoJNI.MocoControlBoundConstraint_setControlPaths(swigCPtr, this, StdVectorString.getCPtr(controlPaths), controlPaths);
  }

  public void clearControlPaths() {
    opensimMocoJNI.MocoControlBoundConstraint_clearControlPaths(swigCPtr, this);
  }

  public StdVectorString getControlPaths() {
    return new StdVectorString(opensimMocoJNI.MocoControlBoundConstraint_getControlPaths(swigCPtr, this), true);
  }

  /**
   *  
   */
  public void setLowerBound(Function f) {
    opensimMocoJNI.MocoControlBoundConstraint_setLowerBound(swigCPtr, this, Function.getCPtr(f), f);
  }

  public void clearLowerBound() {
    opensimMocoJNI.MocoControlBoundConstraint_clearLowerBound(swigCPtr, this);
  }

  public boolean hasLowerBound() {
    return opensimMocoJNI.MocoControlBoundConstraint_hasLowerBound(swigCPtr, this);
  }

  public Function getLowerBound() {
    return new Function(opensimMocoJNI.MocoControlBoundConstraint_getLowerBound(swigCPtr, this), false);
  }

  public void setUpperBound(Function f) {
    opensimMocoJNI.MocoControlBoundConstraint_setUpperBound(swigCPtr, this, Function.getCPtr(f), f);
  }

  public void clearUpperBound() {
    opensimMocoJNI.MocoControlBoundConstraint_clearUpperBound(swigCPtr, this);
  }

  public boolean hasUpperBound() {
    return opensimMocoJNI.MocoControlBoundConstraint_hasUpperBound(swigCPtr, this);
  }

  public Function getUpperBound() {
    return new Function(opensimMocoJNI.MocoControlBoundConstraint_getUpperBound(swigCPtr, this), false);
  }

  /**
   *  Should the control be constrained to be equal to the lower bound (rather<br>
   *  than an inequality constraint)? In this case, the upper bound must be<br>
   *  unspecified.
   */
  public void setEqualityWithLower(boolean v) {
    opensimMocoJNI.MocoControlBoundConstraint_setEqualityWithLower(swigCPtr, this, v);
  }

  public boolean getEqualityWithLower() {
    return opensimMocoJNI.MocoControlBoundConstraint_getEqualityWithLower(swigCPtr, this);
  }

}
