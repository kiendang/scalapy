package ai.kien.python

import org.scalatest.{BeforeAndAfterAllConfigMap, ConfigMap, Suite}

trait PythonSuite extends Suite with BeforeAndAfterAllConfigMap {
  override def beforeAll(configMap: ConfigMap) = {
    Config.pythonExecutable.foreach(System.setProperty("scalapy.python.programname", _))
  }
}
