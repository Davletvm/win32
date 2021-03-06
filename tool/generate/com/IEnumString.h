#include "windows.h"
#include "Shobjidl.h"

// vtable_start 3
MIDL_INTERFACE("00000101-0000-0000-C000-000000000046")
IEnumString : public IUnknown
{
public:
    virtual /* [local] */ HRESULT STDMETHODCALLTYPE Next( 
        /* [in] */ ULONG celt,
        /* [annotation] */ 
        _Out_writes_to_(celt,*pceltFetched)  LPOLESTR *rgelt,
        /* [annotation] */ 
        _Out_opt_  ULONG *pceltFetched) = 0;
    
    virtual HRESULT STDMETHODCALLTYPE Skip( 
        /* [in] */ ULONG celt) = 0;
    
    virtual HRESULT STDMETHODCALLTYPE Reset( void) = 0;
    
    virtual HRESULT STDMETHODCALLTYPE Clone( 
        /* [out] */ __RPC__deref_out_opt IEnumString **ppenum) = 0;
    
};