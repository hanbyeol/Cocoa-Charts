//
//  CCSBandAreaChart.m
//  Cocoa-Charts
//
//  Created by limc on 13-10-27.
//  Copyright 2011 limc.cn All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "CCSBandAreaChart.h"
#import "CCSTitledLine.h"
#import "CCSLineData.h"

@implementation CCSBandAreaChart
@synthesize areaAlpha = _areaAlpha;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initProperty {
    //初始化父类的熟悉
    [super initProperty];
    //去除轴对称属性
    self.areaAlpha = 0.2;
    self.lineAlignType = CCSLineAlignTypeJustify;
}

- (void)drawData:(CGRect)rect {

    // 起始位置
    CCFloat startX;
    CCFloat lastY = 0;
    CCFloat lastX = 0;


    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetAllowsAntialiasing(context, YES);

    if (self.linesData != NULL) {
        //逐条输出MA线
        for (CCInt i = [self.linesData count] - 1; i >= 0; i--) {
            CCSTitledLine *line = [self.linesData objectAtIndex:i];

            if (line != NULL) {
                //设置线条颜色
                CGContextSetStrokeColorWithColor(context, line.color.CGColor);
                //获取线条数据
                NSArray *lineDatas = line.data;
                //判断Y轴的位置设置从左往右还是从右往左绘制
                if (self.axisYPosition == CCSGridChartYAxisPositionLeft) {
                    // 点线距离
                    CCFloat lineLength = ((rect.size.width - self.axisMarginLeft - self.axisMarginRight) / ([line.data count] - 1));
                    //起始点
                    startX = super.axisMarginLeft;
                    //遍历并绘制线条
                    for (CCUInt j = 0; j < [lineDatas count]; j++) {
                        CCSLineData *lineData = [lineDatas objectAtIndex:j];
                        //获取终点Y坐标
                        CCFloat valueY = ((1 - (lineData.value - self.minValue) / (self.maxValue - self.minValue)) * (rect.size.height - 2 * self.axisMarginTop - self.axisMarginBottom) + self.axisMarginTop);
                        //绘制线条路径
                        if (j == 0) {
                            CGContextMoveToPoint(context, startX, valueY);
                        } else {
                            CGContextAddLineToPoint(context, startX, valueY);
                        }
                        lastY = valueY;
                        //X位移
                        startX = startX + lineLength;
                    }
                } else {

                    // 点线距离
                    CCFloat lineLength = ((rect.size.width - self.axisMarginLeft - self.axisMarginRight) / ([line.data count] - 1));
                    //起始点
                    startX = rect.size.width - self.axisMarginRight - self.axisMarginLeft;

                    //判断点的多少
                    if ([lineDatas count] == 0) {
                        //0根则返回
                        return;
                    } else if ([lineDatas count] == 1) {
                        //1根则绘制一条直线
                        CCSLineData *lineData = [lineDatas objectAtIndex:0];
                        //获取终点Y坐标
                        CCFloat valueY = ((1 - (lineData.value - self.minValue) / (self.maxValue - self.minValue)) * (rect.size.height - 2 * self.axisMarginTop - self.axisMarginBottom) + self.axisMarginTop);

                        CGContextMoveToPoint(context, startX, valueY);
                        CGContextAddLineToPoint(context, self.axisMarginLeft, valueY);

                    } else {
                        //遍历并绘制线条
                        for (CCInt j = [lineDatas count] - 1; j >= 0; j--) {
                            CCSLineData *lineData = [lineDatas objectAtIndex:j];
                            //获取终点Y坐标
                            CCFloat valueY = ((1 - (lineData.value - self.minValue) / (self.maxValue - self.minValue)) * (rect.size.height - 2 * self.axisMarginTop - self.axisMarginBottom) + self.axisMarginTop);
                            //绘制线条路径
                            if (j == [lineDatas count] - 1) {
                                CGContextMoveToPoint(context, startX, valueY);
                            } else if (j == 0) {
                                CGContextAddLineToPoint(context, self.axisMarginLeft, valueY);
                            } else {
                                CGContextAddLineToPoint(context, startX, valueY);
                            }

                            lastY = valueY;
                            //X位移
                            startX = startX - lineLength;
                        }
                    }
                }
                //绘制路径
                CGContextStrokePath(context);
            }
        }

        CCSTitledLine *line1 = [self.linesData objectAtIndex:0];
        CCSTitledLine *line2 = [self.linesData objectAtIndex:1];


        if (line1 != NULL && line2 != NULL) {
            //设置线条颜色
            CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
            //获取线条数据
            NSArray *line1Datas = line1.data;
            NSArray *line2Datas = line2.data;

            // 点线距离
            CCFloat lineLength = ((rect.size.width - self.axisMarginLeft - self.axisMarginRight) / ([line1.data count] - 1));
            //起始点
            startX = super.axisMarginLeft;
            //遍历并绘制线条
            for (CCUInt j = 0; j < [line1Datas count]; j++) {
                CCSLineData *line1Data = [line1Datas objectAtIndex:j];
                CCSLineData *line2Data = [line2Datas objectAtIndex:j];

                //获取终点Y坐标
                CCFloat valueY1 = ((1 - (line1Data.value - self.minValue) / (self.maxValue - self.minValue)) * (rect.size.height - 2 * self.axisMarginTop - self.axisMarginBottom) + self.axisMarginTop);
                CCFloat valueY2 = ((1 - (line2Data.value - self.minValue) / (self.maxValue - self.minValue)) * (rect.size.height - 2 * self.axisMarginTop - self.axisMarginBottom) + self.axisMarginTop);

                //绘制线条路径
                if (j == 0) {
                    CGContextMoveToPoint(context, startX, valueY1);
                    CGContextAddLineToPoint(context, startX, valueY2);
                    CGContextMoveToPoint(context, startX, valueY1);
                } else {
                    CGContextAddLineToPoint(context, startX, valueY1);
                    CGContextAddLineToPoint(context, startX, valueY2);
                    CGContextAddLineToPoint(context, lastX, lastY);

                    CGContextClosePath(context);
                    CGContextMoveToPoint(context, startX, valueY1);
                }
                lastX = startX;
                lastY = valueY2;
                //X位移
                startX = startX + lineLength;
            }
            CGContextClosePath(context);
            CGContextSetAlpha(context, self.areaAlpha);
            CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
            CGContextFillPath(context);

        }

    }
}

@end
