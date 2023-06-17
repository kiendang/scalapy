package ai.kien.python

import org.scalatest.{BeforeAndAfterAll, Suite}

trait PythonSuite extends Suite with BeforeAndAfterAll {
  override def beforeAll() = {
    Config.pythonExecutable.foreach(System.setProperty("scalapy.python.programname", _))
  }
}
