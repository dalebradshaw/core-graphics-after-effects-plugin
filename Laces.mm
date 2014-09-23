//Some of the code following carries this Adobe Copyright

/*******************************************************************/
/*                                                                 */
/*                      ADOBE CONFIDENTIAL                         */
/*                   _ _ _ _ _ _ _ _ _ _ _ _ _                     */
/*                                                                 */
/* Copyright 2007 Adobe Systems Incorporated                       */
/* All Rights Reserved.                                            */
/*                                                                 */
/* NOTICE:  All information contained herein is, and remains the   */
/* property of Adobe Systems Incorporated and its suppliers, if    */
/* any.  The intellectual and technical concepts contained         */
/* herein are proprietary to Adobe Systems Incorporated and its    */
/* suppliers and may be covered by U.S. and Foreign Patents,       */
/* patents in process, and are protected by trade secret or        */
/* copyright law.  Dissemination of this information or            */
/* reproduction of this material is strictly forbidden unless      */
/* prior written permission is obtained from Adobe Systems         */
/* Incorporated.                                                   */
/*                                                                 */
/*******************************************************************/


#include "Laces.h"

float treshold(float x,float tr);
void drawLinkBetweenPoints(NSPoint startPoint, NSPoint endPoint, NSColor *insideColor);

static PF_Err 
About (	
	PF_InData		*in_data,
	PF_OutData		*out_data,
	PF_ParamDef		*params[],
	PF_LayerDef		*output )
{
	AEGP_SuiteHandler suites(in_data->pica_basicP);
	
	suites.ANSICallbacksSuite1()->sprintf(	out_data->return_msg,
											"%s v%d.%d\r%s",
											STR(StrID_Name), 
											MAJOR_VERSION, 
											MINOR_VERSION, 
											STR(StrID_Description));
	return PF_Err_NONE;
}

static PF_Err 
GlobalSetup (	
	PF_InData		*in_data,
	PF_OutData		*out_data,
	PF_ParamDef		*params[],
	PF_LayerDef		*output )
{
	out_data->my_version = PF_VERSION(	MAJOR_VERSION, 
										MINOR_VERSION,
										BUG_VERSION, 
										STAGE_VERSION, 
										BUILD_VERSION);

	out_data->out_flags = 	PF_OutFlag_I_EXPAND_BUFFER				 |
                            PF_OutFlag_I_HAVE_EXTERNAL_DEPENDENCIES;
	out_data->out_flags2 =  PF_OutFlag2_NONE;
    
	return PF_Err_NONE;
}

static PF_Err 
ParamsSetup (	
	PF_InData		*in_data,
	PF_OutData		*out_data,
	PF_ParamDef		*params[],
	PF_LayerDef		*output )
{
	PF_Err		err		= PF_Err_NONE;
	PF_ParamDef	def;	

    AEFX_CLR_STRUCT(def);

    PF_ADD_POINT(STR(StrID_Point1_Param_Name), 10, 10, NULL, POSITION1_DISK_ID);
     
    AEFX_CLR_STRUCT(def);
    PF_ADD_POINT(STR(StrID_Point2_Param_Name), 50, 50, NULL, POSITION2_DISK_ID);
	out_data->num_params = LACES_NUM_PARAMS;

	return err;
}

float treshold(float x,float tr)
{
	return (x>0)?((x>tr)?x:tr):-x+tr;
}

//  drawing method carries the following copyright
//  Copyright 2006 Edouard FISCHER. All rights reserved.
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//	-	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//	-	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//	-	Neither the name of Edouard FISCHER nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

void drawLinkBetweenPoints(NSPoint startPoint, NSPoint endPoint, NSColor *insideColor) {
        NSAutoreleasePool *pool =  [[NSAutoreleasePool alloc] init];
    
        // a lace is made of an outside gray line of width 5, and a inside insideColor(ed) line of width 3
        
        NSPoint p0 = NSMakePoint(startPoint.x,startPoint.y );
        NSPoint p3 = NSMakePoint(endPoint
                                 .x,endPoint.y );
        
        NSPoint p1 = NSMakePoint(startPoint.x+treshold((endPoint.x - startPoint.x)/2,50),startPoint.y);
        NSPoint p2 = NSMakePoint(endPoint.x -treshold((endPoint.x - startPoint.x)/2,50),endPoint.y);	
        
        //p0 and p1 are on the same horizontal line
        //distance between p0 and p1 is set with the treshold fuction
        //the same holds for p2 and p3
        
        NSBezierPath* path = [NSBezierPath bezierPath];
        [path setLineWidth:0];
        [[NSColor grayColor] set];
        [path appendBezierPathWithOvalInRect:NSMakeRect(startPoint.x-2.5,startPoint.y-2.5,5,5)];
        [path fill];
        
    
        path = [NSBezierPath bezierPath];
        [path setLineWidth:0];
        [insideColor set];
        [path appendBezierPathWithOvalInRect:NSMakeRect(startPoint.x-1.5,startPoint.y-1.5,3,3)];
        [path fill];
        
    
        path = [NSBezierPath bezierPath];
        [path setLineWidth:0];
        [[NSColor grayColor] set];
        [path appendBezierPathWithOvalInRect:NSMakeRect(endPoint.x-2.5,endPoint.y-2.5,5,5)];
        [path fill];
        
    
        path = [NSBezierPath bezierPath];
        [path setLineWidth:0];
        [insideColor set];
        [path appendBezierPathWithOvalInRect:NSMakeRect(endPoint.x-1.5,endPoint.y-1.5,3,3)];
        [path fill];
       
    
        path = [NSBezierPath bezierPath];
        [path setLineWidth:5];
        [path moveToPoint:p0];
        [path curveToPoint:p3 controlPoint1:p1 controlPoint2:p2];
        [[NSColor grayColor] set];
        [path stroke];
        
        
        path = [NSBezierPath bezierPath];
        [path setLineWidth:3];
        [path moveToPoint:p0];
        [path curveToPoint:p3 controlPoint1:p1 controlPoint2:p2];
        [insideColor set];
        [path stroke];
        
        [pool drain];
}


static PF_Err 
Render (
	PF_InData		*in_data,
	PF_OutData		*out_data,
	PF_ParamDef		*params[],
	PF_LayerDef		*output )
{
	PF_Err				err		= PF_Err_NONE;
	AEGP_SuiteHandler	suites(in_data->pica_basicP);


    PF_EffectWorld	*inputP		=	&params[0]->u.ld;
    PF_EffectWorld	quartz_world;
	A_long				widthL	=	output->width,
    heightL	=	output->height;
    
    PF_Handle bufferH	= NULL;
    bufferH = suites.HandleSuite1()->host_new_handle(((inputP->width* inputP->height)* sizeof(GL_RGBA)));
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    CGContextRef cg;
    try
	{
        AEFX_CLR_STRUCT(quartz_world);	
		ERR(suites.WorldSuite1()->new_world(	in_data->effect_ref,
                                            widthL,
                                            heightL,
                                            PF_NewWorldFlag_CLEAR_PIXELS,
                                            &quartz_world));
        
        if (bufferH)
        {
            unsigned int *bufferP = reinterpret_cast<unsigned int*>(suites.HandleSuite1()->host_lock_handle(bufferH));
            
        
            for (int ix=0; ix < inputP->height; ++ix)
            {
                PF_Pixel8 *pixelDataStart = NULL;
                PF_GET_PIXEL_DATA8( inputP , NULL, &pixelDataStart);
                ::memcpy(	bufferP + (ix * inputP->width ),
                         pixelDataStart + (ix * (inputP->rowbytes)/sizeof(GL_RGBA)),
                         inputP->width * sizeof(GL_RGBA));
            }
            
            cg = CGBitmapContextCreateWithData(bufferP,in_data->width,in_data->height,8, in_data->width * 4, colorSpace, kCGImageAlphaPremultipliedFirst,NULL,NULL);
            
            if(cg == NULL) {
                NSLog(@"Error creating context");  
            }

            A_long				linesL	= 0;
            
            linesL 		= output->extent_hint.bottom - output->extent_hint.top;
                   
            CGAffineTransform flipVertical = CGAffineTransformMake(
                                                                   1, 0, 0, -1, 0, in_data->height
                                                                   );
            CGContextConcatCTM(cg , flipVertical);
            
            NSGraphicsContext *nsGraphicsContext;
            nsGraphicsContext = [NSGraphicsContext graphicsContextWithGraphicsPort:cg
                                                                           flipped:NO];
            //Uncomment the following for non-antialiased drawing
            //[nsGraphicsContext setShouldAntialias:NO];
            //CGContextSetAllowsAntialiasing(cg ,NO);
            
            [NSGraphicsContext saveGraphicsState];
            [NSGraphicsContext setCurrentContext:nsGraphicsContext];
            
            //NSLog(@"%i, %i, %i, %i",FIX_2_FLOAT(params[LACES_POSITION1]->u.td.x_value),FIX_2_FLOAT(params[LACES_POSITION1]->u.td.y_value),FIX_2_FLOAT(params[LACES_POSITION2]->u.td.x_value),FIX_2_FLOAT(params[LACES_POSITION2]->u.td.y_value));
            
            NSPoint startPoint = NSMakePoint(FIX_2_FLOAT(params[LACES_POSITION1]->u.td.x_value), FIX_2_FLOAT(params[LACES_POSITION1]->u.td.y_value));
            NSPoint endPoint = NSMakePoint(FIX_2_FLOAT(params[LACES_POSITION2]->u.td.x_value), FIX_2_FLOAT(params[LACES_POSITION2]->u.td.y_value));
            
            drawLinkBetweenPoints(startPoint, endPoint, [NSColor yellowColor]);
            
            [NSGraphicsContext restoreGraphicsState];
            [nsGraphicsContext flushGraphics];
            
            CGContextRelease(cg);
    
            for (int ix=0; ix < quartz_world.height; ++ix)
            {
                PF_Pixel8 *pixelDataStart = NULL;
                PF_GET_PIXEL_DATA8( &quartz_world , NULL, &pixelDataStart);
                ::memcpy(	pixelDataStart + (ix * quartz_world.rowbytes/sizeof(GL_RGBA)),
                         bufferP + (ix * output->width ),
                         quartz_world.width * sizeof(GL_RGBA));
            }

            suites.HandleSuite1()->host_unlock_handle(bufferH);
            suites.HandleSuite1()->host_dispose_handle(bufferH);
            
        } else
		{
			CHECK(PF_Err_OUT_OF_MEMORY);
            
        }
        
        if (PF_Quality_HI == in_data->quality) {
			ERR(suites.WorldTransformSuite1()->copy_hq(	in_data->effect_ref,
                                                       &quartz_world,
                                                       output,
                                                       NULL,
                                                       NULL));
		}
		else
		{
			ERR(suites.WorldTransformSuite1()->copy(	in_data->effect_ref,
                                                    &quartz_world,
                                                    output,
                                                    NULL,
                                                    NULL));
            
		}
		
		ERR( suites.WorldSuite1()->dispose_world( in_data->effect_ref, &quartz_world));
		ERR(PF_ABORT(in_data));
        
    }
    catch(PF_Err& thrown_err)
    {
        err = thrown_err;
    }
   
   	return err;
}


DllExport	
PF_Err 
EntryPointFunc (
	PF_Cmd			cmd,
	PF_InData		*in_data,
	PF_OutData		*out_data,
	PF_ParamDef		*params[],
	PF_LayerDef		*output,
	void			*extra)
{
	PF_Err		err = PF_Err_NONE;
	
	try {
		switch (cmd) {
			case PF_Cmd_ABOUT:

				err = About(in_data,
							out_data,
							params,
							output);
				break;
				
			case PF_Cmd_GLOBAL_SETUP:

				err = GlobalSetup(	in_data,
									out_data,
									params,
									output);
				break;
				
			case PF_Cmd_PARAMS_SETUP:

				err = ParamsSetup(	in_data,
									out_data,
									params,
									output);
				break;
				
			case PF_Cmd_RENDER:

				err = Render(	in_data,
								out_data,
								params,
								output);
				break;
		}
	}
	catch(PF_Err &thrown_err){
		err = thrown_err;
	}
	return err;
}

