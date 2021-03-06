// Copyright 2016 The Charon Platform Authors.
// All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include <cmath>
#include <charon/base>

int math::abs(int number)
{
  return std::abs(number);
}

double math::acos(double number)
{
  return std::acos(number);
}

double math::asin(double number)
{
  return std::asin(number);
}

double math::atan(double number)
{
  return std::atan(number);
}

double math::atan2(double x, double y)
{
  return std::atan2(x, y);
}

double math::ceil(double number)
{
  return std::ceil(number);
}

double math::cos(double number)
{
  return std::cos(number);
}

double math::cosh(double number)
{
  return std::cosh(number);
}

double math::exp(double number)
{
  return std::exp(number);
}

double math::floor(double number)
{
  return std::floor(number);
}

double math::fmod(double number, double denom)
{
  return std::fmod(number, denom);
}

double math::round(double number, int precision)
{
  double dprecision = std::pow(10, precision);
  return std::floor((number + (0.5/(dprecision))) * (dprecision)) / dprecision;
}

double math::truncate(double number, int precision)
{
  double dprecision = std::pow(10, precision);
  return std::floor(number * (dprecision)) / dprecision;
}
