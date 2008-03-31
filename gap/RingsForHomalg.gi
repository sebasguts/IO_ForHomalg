#############################################################################
##
##  RingsForHomalg.gi         RingsForHomalg package         Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementation stuff for homalg.
##
#############################################################################

####################################
#
# global variables:
#
####################################

# a central place for configuration variables:

InstallValue( HOMALG_RINGS,
        rec(
            SaveHomalgMaximumBackStream := false,
            color_display := "false"
           )
);

####################################
#
# constructor functions:
#
####################################

##
InstallGlobalFunction( RingForHomalg,
  function( arg )
    local nargs, properties, ar, stream, init, table, ext_obj;
    
    nargs := Length( arg );
    
    properties := [ ];
    
    for ar in arg{[ 2 .. nargs ]} do
        if not IsBound( init ) and IsHomalgExternalRingRep( ar ) then
            init := ar;
        elif not IsBound( init ) and IsHomalgExternalObject( ar )
          and HasIsHomalgExternalObjectWithIOStream( ar ) and IsHomalgExternalObjectWithIOStream( ar ) then
            init := ar;
        elif IsFilter( ar ) then
            Add( properties, ar );
        else
            Error( "this argument should be in { IsString, IsFilter, IsHomalgExternalRingRep, IsHomalgExternalObjectWithIOStream } bur recieved: ", ar,"\n" );
        fi;
    od;
    
    if Length( arg ) > 1 and IsFilter( arg[2] ) then
        ext_obj := HomalgSendBlocking( [ "CreateHomalgRing(", arg[1], ")" ], init );
    else
        ext_obj := HomalgSendBlocking( [ "CreateHomalgRing(", arg[1], ")" ], IsHomalgRingInExternalGAP, init );
    fi;
    
    return CreateHomalgRing( ext_obj, IsHomalgExternalObjectWithIOStream );
    
end );

##
InstallGlobalFunction( RingForHomalgInExternalGAP,
  function( arg )
    local stream, init, table, ext_obj;
    
    stream := LaunchCAS( HOMALG_IO_GAP );
    
    init := HomalgExternalObject( "", "GAP", stream );
    
    HomalgSendBlocking( "LoadPackage(\"homalg\")", "need_command", init );
    
    if Length( arg ) > 1 and IsFilter( arg[2] ) then
        ext_obj := HomalgSendBlocking( [ "CreateHomalgRing(", arg[1], ")" ], arg[2], init );
    else
        ext_obj := HomalgSendBlocking( [ "CreateHomalgRing(", arg[1], ")" ], IsHomalgRingInExternalGAP, init );
    fi;
    
    return CreateHomalgRing( ext_obj, IsHomalgExternalObjectWithIOStream );
    
end );

##
InstallGlobalFunction( RingForHomalgInSage,
  function( arg )
    local stream, ext_obj;
    
    stream := LaunchCAS( HOMALG_IO_Sage );
    
    if Length( arg ) > 1 and IsFilter( arg[2] ) then
        ext_obj := HomalgExternalObject( arg[1], "Sage", stream, arg[2] );
    else
        ext_obj := HomalgExternalObject( arg[1], "Sage", stream, IsHomalgRingInSage );
    fi;
    
    return CreateHomalgRing( ext_obj, IsHomalgExternalObjectWithIOStream );
    
end );

##
InstallGlobalFunction( RingForHomalgInMAGMA,
  function( arg )
    local stream, ext_obj;
    
    stream := LaunchCAS( HOMALG_IO_MAGMA );
    
    if Length( arg ) > 1 and IsFilter( arg[2] ) then
        ext_obj := HomalgExternalObject( arg[1], "MAGMA", stream, arg[2] );
    else
        ext_obj := HomalgExternalObject( arg[1], "MAGMA", stream, IsHomalgRingInMAGMA );
    fi;
    
    return CreateHomalgRing( ext_obj, IsHomalgExternalObjectWithIOStream );
    
end );

##
InstallGlobalFunction( RingForHomalgInPIRMaple,
  function( arg )
    local stream, init, table, ext_obj;
    
    stream := LaunchCAS( HOMALG_IO_Maple );
    
    init := HomalgExternalObject( "", "Maple", stream );
    
    HomalgSendBlocking( "with(PIR): with(homalg)", "need_command", init );
    
    table := HomalgSendBlocking( "`PIR/homalg`", init );
    
    HomalgSendBlocking( [ "homalg_options(", table, ")" ], "need_command" );
    
    if Length( arg ) > 1 and IsFilter( arg[2] ) then
        ext_obj := HomalgSendBlocking( [ arg[1], ",", table ], arg[2] );
    else
        ext_obj := HomalgSendBlocking( [ arg[1], ",", table ], IsHomalgRingInMaplePIR );
    fi;
    
    return CreateHomalgRing( ext_obj, IsHomalgExternalObjectWithIOStream );
    
end );

##
InstallGlobalFunction( RingForHomalgInInvolutiveMaple,
  function( arg )
    local stream, init, table, ext_obj;
    
    stream := LaunchCAS( HOMALG_IO_Maple );
    
    init := HomalgExternalObject( "", "Maple", stream );
    
    HomalgSendBlocking( "with(Involutive): with(homalg)", "need_command", init );
    
    table := HomalgSendBlocking( "`Involutive/homalg`", init );
    
    HomalgSendBlocking( [ "homalg_options(", table, ")" ], "need_command" );
    
    if Length( arg ) > 1 and IsFilter( arg[2] ) then
        ext_obj := HomalgSendBlocking( [ arg[1], ",", table ], arg[2] );
    else
        ext_obj := HomalgSendBlocking( [ arg[1], ",", table ], IsHomalgRingInMapleInvolutive );
    fi;
    
    return CreateHomalgRing( ext_obj, IsHomalgExternalObjectWithIOStream );
    
end );

##
InstallGlobalFunction( RingForHomalgInJanetMaple,
  function( arg )
    local stream, init, table, ext_obj;
    
    stream := LaunchCAS( HOMALG_IO_Maple );
    
    init := HomalgExternalObject( "", "Maple", stream );
    
    HomalgSendBlocking( "with(Janet): with(homalg)", "need_command", init );
    
    table := HomalgSendBlocking( "`Janet/homalg`", init );
    
    HomalgSendBlocking( [ "homalg_options(", table, ")" ], "need_command" );
    
    if Length( arg ) > 1 and IsFilter( arg[2] ) then
        ext_obj := HomalgSendBlocking( [ arg[1], ",", table ], arg[2] );
    else
        ext_obj := HomalgSendBlocking( [ arg[1], ",", table ], IsHomalgRingInMapleJanet );
    fi;
    
    return CreateHomalgRing( ext_obj, IsHomalgExternalObjectWithIOStream );
    
end );

##
InstallGlobalFunction( RingForHomalgInJanetOreMaple,
  function( arg )
    local stream, init, table, ext_obj;
    
    stream := LaunchCAS( HOMALG_IO_Maple );
    
    init := HomalgExternalObject( "", "Maple", stream );
    
    HomalgSendBlocking( "with(JanetOre): with(homalg)", "need_command", init );
    
    table := HomalgSendBlocking( "`JanetOre/homalg`", init );
    
    HomalgSendBlocking( [ "homalg_options(", table, ")" ], "need_command" );
    
    if Length( arg ) > 1 and IsFilter( arg[2] ) then
        ext_obj := HomalgSendBlocking( [ arg[1], ",", table ], arg[2] );
    else
        ext_obj := HomalgSendBlocking( [ arg[1], ",", table ], IsHomalgRingInMapleJanetOre );
    fi;
    
    return CreateHomalgRing( ext_obj, IsHomalgExternalObjectWithIOStream );
    
end );

##
InstallGlobalFunction( RingForHomalgInOreModulesMaple,
  function( arg )
    local stream, init, table, ext_obj;
    
    stream := LaunchCAS( HOMALG_IO_Maple );
    
    init := HomalgExternalObject( "", "Maple", stream );
    
    HomalgSendBlocking( "with(OreModules): with(homalg)", "need_command", init );
    
    table := HomalgSendBlocking( "`OreModules/homalg`", init );
    
    HomalgSendBlocking( [ "homalg_options(", table, ")" ], "need_command" );
    
    if Length( arg ) > 1 and IsFilter( arg[2] ) then
        ext_obj := HomalgSendBlocking( [ arg[1], ",", table ], arg[2] );
    else
        ext_obj := HomalgSendBlocking( [ arg[1], ",", table ], IsHomalgRingInMapleOreModules );
    fi;
    
    return CreateHomalgRing( ext_obj, IsHomalgExternalObjectWithIOStream );
    
end );

####################################
#
# View, Print, and Display methods:
#
####################################

InstallMethod( Display,
        "for homalg matrices",
        [ IsHomalgExternalRingRep ],
        
  function( o )
    local RP, ring, stream, cas, display_color;
    
    RP := HomalgTable( o );
    
    if IsBound(RP!.RingName) then
        
        if IsFunction( RP!.RingName ) then
            ring := RP!.RingName( o );
        else
            ring := RP!.RingName;
        fi;
        
        stream := HomalgStream( o );
        
        if not IsBound( stream.cas ) then ## enforce saving the normalized name of the CAS in the stream
            HomalgSendBlocking( "\"hello world\"", o, "need_command" );
        fi;
        
        ## the normalized name of the CAS is now saved in the stream
        cas := stream.cas;
        
        if IsBound( stream.color_display ) then
            display_color := stream.color_display;
        else
            display_color := "";
        fi;
        
        if cas = "gap" then
            Print( display_color, ring, "\n\033[0m" );
        elif cas = "maple" then
            Print( display_color, ring, "\n\033[0m" );
        else
            Print( display_color, ring, "\n\033[0m" );
        fi;
        
    else
        
        TryNextMethod( );
        
    fi;
    
end);

InstallMethod( Display,
        "for homalg matrices",
        [ IsHomalgExternalMatrixRep ],
        
  function( o )
    local stream, cas, display_color;
    
    stream := HomalgStream( o );
    
    if not IsBound( stream.cas ) then ## enforce saving the normalized name of the CAS in the stream
        HomalgSendBlocking( "\"hello world\"", HomalgRing( o ), "need_command" );
    fi;
    
    ## the normalized name of the CAS is now saved in the stream
    cas := stream.cas;
    
    if IsBound( stream.color_display ) then
        display_color := stream.color_display;
    else
        display_color := "";
    fi;
    
    if cas = "gap" then
        Print( display_color, HomalgSendBlocking( [ "Display(", o, ")" ], "need_display" ), "\033[0m" );
    elif cas = "maple" then
        Print( display_color, HomalgSendBlocking( [ "convert(", o, ",matrix)" ], "need_display" ), "\033[0m" );
    else
        Print( display_color, HomalgSendBlocking( [ o ], "need_display" ), "\033[0m" );
    fi;
    
end);
