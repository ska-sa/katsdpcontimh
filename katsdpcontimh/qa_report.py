################################################################################
# Copyright (c) 2022, National Research Foundation (SARAO)
#
# Licensed under the BSD 3-Clause License (the "License"); you may not use
# this file except in compliance with the License. You may obtain a copy
# of the License at
#
#   https://opensource.org/licenses/BSD-3-Clause
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

import numpy as np

from typing import Any
try:
    from numpy.typing import ArrayLike
except ImportError:
    ArrayLike = Any  # type: ignore


ONE_DAY_IN_SECONDS = 24*60*60.0
MAX_AIPS_PATH_LEN = 12
LIGHTSPEED = 299792458.0

""" Map correlation characters to correlation id """
CORR_ID_MAP = {('h', 'h'): 0,
               ('v', 'v'): 1,
               ('h', 'v'): 2,
               ('v', 'h'): 3}


def katdal_timestamps(timestamps: ArrayLike, midnight: float) -> ArrayLike:
    """
    Given AIPS Julian day timestamps offset from midnight on the day
    of the observation, calculates the katdal UTC timestamp
    Parameters
    ----------
    timestamsp : np.ndarray
        AIPS Julian Day timestamps, offset from midnight on the
        observation date.
    midnight : float
        midnight on day of observation in UTC
    Returns
    -------
    np.ndarray
        katdal UTC timestamps
    """
    return midnight + (timestamps * ONE_DAY_IN_SECONDS)
