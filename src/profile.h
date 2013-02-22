#ifndef PROFILE_H
#define PROFILE_H


#include <ctime>
#include <map>
#define WIN32_LEAN_AND_MEAN
#include <Windows.h>


class TProfile {
public:
  TProfile(const char *functionName)
    : m_FunctionName(functionName)
  {
    m_Valid = QueryPerformanceCounter(&m_Start);
  }

  ~TProfile() {
    if (m_Valid) {
      LARGE_INTEGER end;
      if (!QueryPerformanceCounter(&end)) {
        return;
      }
      LONGLONG diff = end.QuadPart - m_Start.QuadPart;

      LARGE_INTEGER frequency;
      if (!QueryPerformanceFrequency(&frequency)) {
        return;
      }

      registerTime(m_FunctionName, double(diff) / double(frequency.QuadPart));
    }
  }

  static void displayProfile();

private:
  struct Time {
    Time() : m_Min(DBL_MAX), m_Sum(0.0), m_Max(0.0), m_Count(0) {}

    double m_Min;
    double m_Sum;
    double m_Max;
    unsigned long m_Count;
  };
private:
  static void registerTime(const char *functionName, double timeMS) {
    std::pair<std::map<const char*, Time>::iterator, bool> iter = s_Times.insert(std::make_pair(functionName, Time()));
    std::map<const char*, Time>::iterator timeIter = iter.first;

    if (timeMS < timeIter->second.m_Min) {
      timeIter->second.m_Min = timeMS;
    }
    if (timeMS > timeIter->second.m_Max) {
      timeIter->second.m_Max = timeMS;
    }
    timeIter->second.m_Sum += timeMS;
    ++timeIter->second.m_Count;
    time_t now = time(NULL);
    if (now - s_LastDisplay > 60) {
      displayProfile();
      s_LastDisplay = now;
    }
  }

private:

  static std::map<const char*, Time> s_Times;
  static time_t s_LastDisplay;

  LARGE_INTEGER m_Start;
  const char *m_FunctionName;
  BOOL m_Valid;
};


//#define PROFILE() TProfile __FUNCTION__ ## prof(__FUNCSIG__);
//#define PROFILEN(name) TProfile name ## prof(#name);
//#define PROFILE() LOGDEBUG("%s", __FUNCSIG__)
#define PROFILE()
#define PROFILEN(name)


#endif // PROFILE_H