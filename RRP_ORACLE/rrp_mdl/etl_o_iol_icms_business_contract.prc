CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_BUSINESS_CONTRACT(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_ICMS_BUSINESS_CONTRACT
  *  功能描述：合同信息表
  *  创建日期：20251117
  *  开发人员：于敬艺
  *  来源表： IOL.V_ICMS_BUSINESS_CONTRACT
  *  目标表： O_IOL_ICMS_BUSINESS_CONTRACT
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251117  YJY     首次创建
                2    20260318  YJY     新增
  *************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ICMS_BUSINESS_CONTRACT'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_BUSINESS_CONTRACT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-合同信息表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ICMS_BUSINESS_CONTRACT NOLOGGING
    (     SERIALNO                      --合同编号
         ,BAPSERIALNO                   --批复编号
         ,RELACONTRACTNO                --关联合同编号
         ,ARTIFICIALNO                  --文本合同编号
         ,CUSTOMERID                    --客户编号
         ,CUSTOMERNAME                  --客户名称
         ,BUSINESSFLAG                  --额度/业务标志
         ,OLDCONTRACTNO                 --关联的旧合同号
         ,APPLYTYPE                     --申请类型
         ,OCCURTYPE                     --贷款发放类型
         ,OCCURDATE                     --签订日期
         ,CURRENCY                      --额度/业务币种
         ,BUSINESSSUM                   --合同金额
         ,PUTOUTSUM                     --实际放款金额
         ,PUTOUTDATE                    --放款日期
         ,BASEPRODUCT                   --基础产品(额度)基础产品
         ,PRODUCTID                     --产品编号
         ,POLICYID                      --产品政策编号
         ,POLICYVERSIONID               --产品政策版本编号
         ,PRODUCTCLASSIFY               --产品所属大类
         ,TERMMONTH                     --期限(月)
         ,TERMDAY                       --期限(天)
         ,STARTDATE                     --合同开始日期
         ,MATURITY                      --合同到期日期
         ,ISCYCLE                       --是否循环(额度)是否循环
         ,RISKTYPE                      --风险类型(额度)风险类型（一般、低风险）
         ,ISLOWRISK                     --是否低风险业务
         ,ISREMOTEBUSINESS              --是否异地业务
         ,RATEMODEL                     --利率模式利率模式(1固定利率2浮动利率3组合利率)
         ,FIXEDRATE                     --固定利率
         ,BASERATETYPE                  --基准利率类型
         ,BASERATE                      --基准利率
         ,RATEFLOATTYPE                 --利率浮动方式
         ,RATEADJUSTTYPE                --利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
         ,FLOATRANGE                    --浮动幅度
         ,EXECUTERATE                   --执行利率
         ,VOUCHTYPE                     --主担保方式
         ,HAVEADDITIONALVOUCH           --有无追加担保方式
         ,OTHERVOUCHTYPE                --其他担保方式
         ,ADDITIONCOMMAND               --其他条件和要求
         ,REPAYTYPE                     --还款方式码值为：repaytype
         ,REPAYCYCLE                    --还款周期还款周期(1月2季3一次4半年5年6双月)
         ,REPAYDATE                     --指定还款日
         ,SETTLEMENTACCOUNT             --结算账号
         ,PAYMENTTYPE                   --支付方式
         ,CREDITINVEST                  --授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)
         ,NATIONALINDUSTRYTYPE          --贷款投向行业
         ,INTRAINDUSTRYTYPE             --行内行业投向
         ,PURPOSE                       --用途
         ,RESERVESUM                    --预留金额
         ,BALANCE                       --合同贷款余额
         ,NORMALBALANCE                 --正常余额
         ,OVERDUEBALANCE                --逾期/垫款金额
         ,DULLBALANCE                   --呆滞余额
         ,BADBALANCE                    --呆账余额
         ,INNERINTERESTBALANCE          --表内欠息余额
         ,OUTERINTERESTBALANCE          --表外欠息余额
         ,CAPITALPENALTYBALANCE         --逾期罚息余额
         ,INTERESTPENALTYBALANCE        --复息余额
         ,OVERDUEDAYS                   --贷款逾期天数
         ,OWNINTERESTDAYS               --欠息天数
         ,GRACEPERIOD                   --贷款宽限期
         ,CANCELSUM                     --核销本金
         ,CANCELINTEREST                --核销利息
         ,PREDICTLOSTSUM                --预测损失金额
         ,REDUCERESERVESUM              --计提准备金额
         ,BADCONFIRMDATE                --首次认定不良日期
         ,CLASSIFYRESULT                --贷款五级分类
         ,CLASSIFYDATE                  --风险分类日期
         ,STATUS                        --合同状态
         ,FINISHDATE                    --终结日期
         ,FINISHTYPE                    --终结类型
         ,FINISHFLAG                    --结清标志
         ,CONTRACTTYPE                  --合同类型合同类型(一般合同/虚拟合同)
         ,OFFSHEETFLAG                  --表内外标志
         ,BELONGDEPT                    --所属条线BelongDept
         ,COMPLETEFLAG                  --数据录入完整性标识
         ,FLOWTYPE                      --流程类型
         ,APPROVESTATUS                 --审批状态
         ,CLNO                          --额度编号
         ,CLEFFECTSTATUS                --额度续作状态
         ,REMARK                        --备注
         ,OPERATEUSERID                 --业务经办人编号
         ,OPERATEORGID                  --经办机构
         ,OPERATEDATE                   --经办日期
         ,INPUTUSERID                   --登记人
         ,INPUTORGID                    --登记机构
         ,INPUTDATE                     --登记日期
         ,UPDATEUSERID                  --更新人
         ,UPDATEORGID                   --更新机构
         ,UPDATEDATE                    --更新日期
         ,REINFORCEFLAG                 --补充标志
         ,CORPORGID                     --法人机构编号
         ,PAYFREQUENCYUNIT              --指定周期单位
         ,PAYFREQUENCY                  --指定周期
         ,RENEWTERMDATE                 --展期前到期日
         ,RENEWTOTALSUM                 --展期前金额
         ,RENEWEXECUTEYEARRATE          --展期前执行年利率
         ,ISBANKREL                     --是否我行关联方标志
         ,VOUCHTYPE3                    --主要担保方式3
         ,VOUCHTYPE2                    --主要担保方式2
         ,LOANUSETYPE                   --贷款用途
         ,TOTALSUM                      --额度敞口金额
         ,OUTSTNDLMT                    --已占用额度
         ,BAILRATIO                     --保证金比例（%）
         ,BAILSUM                       --保证金金额
         ,TOTALBALANCE                  --敞口余额(元)
         ,CREDITAGGREEMENT              --额度协议流水号
         ,VOUCHTYPEINNER                --担保方式（内部口径）
         ,EXECUTEMONTHRATE              --执行月利率
         ,CLASSIFYRESULTELEVEN          --风险分类结果（11级）
         ,PIGEONHOLEDATE                --归档日期
         ,FREEZEFLAG                    --冻结标志
         ,RATEADJUSTFREQUENCY           --利率调整周期
         ,OVERDUERATE                   --逾期执行利率
         ,OVERDUERATEFLOATTYPE          --逾期利率浮动方式
         ,OVERDUERATEFLOATVALUE         --逾期利率浮动值
         ,PUTOUTORGID                   --出账机构编号(核心机构)
         ,SETTLEMENTACCOUNTNAME         --结算账户(还款账户)名
         ,LOANACCOUNTNO                 --入账账户
         ,LOANACCOUNTNAME               --贷款入账(收款账户)账户名
         ,LOANACCOUNTORGID              --贷款入账(收款账户)账户开户机构
         ,BAILCURRENCY                  --保证金币种
         ,BAILACCOUNT                   --保证金帐号
         ,BAILTRANSACCOUNT              --保证金转出账号
         ,MIGTFLAG                      --迁移标志：crs rcr ilc upl
         ,MANAGEUSERID                  --贷后管理人员
         ,MANAGEORGID                   --贷后管理机构
         ,ISPAGERCONTRACT               --是否签署纸质合同
         ,ISOCCUPYCREDIT                --是否占用他用额度
         ,OCCUPYCREDITBAPSERIALNO       --他用额度批复流水号
         ,OCCUPYCREDITTYPE              --他用额度类型
         ,REMART                        --计量标记
         ,CREDITAUTHNO                  --征信授权影像流水号
         ,ISQUERYCREDITREPORT           --是否自动查询贷后报告
         ,AUTHOSTRDATE                  --授权起始日
         ,ISONLINEBUSINESS              --是否线上业务：yes-是no/空-否
         ,OLDSTATUS                     --备份生效标志
         ,OLDCREDITAGGREEMENT           --使用授信协议号(备份额度合同流水号)
         ,MIGTCUSTOMERID                --转换前客户号
         ,MIGTBUSINESSTYPE              --转换前产品ID
         ,MIGTOLDVALUE                  --迁移数据-参数转换前字段值
         ,CONTRACTNOBEFOREEXTEND        --展期前合同
         ,PDGRATIO                      --手续费比率
         ,PDGSUM                        --手续费金额
         ,TEMPLETEURL                   --同业模板页面路径
         ,TEMPLETENO                    --同业模板编号
         ,VOUCHFLAG                     --有无其他担保方式，HaveNot
         ,RATEFLOATRATIOORBP            --利率浮动类型（1-按比例2-按点差）
         ,ADVANCEDMANUFLAG              --先进制造业标志（0-否，1-是）
         ,CULTUREINDUSTRYFLAG           --文化产业标志（0-否，1-是）
         ,ONLYNEWENTFLAG                --专精特新中小企业标志（0-否，1-是）
         ,ONLYNEWSMALLENTFLAG           --专精特新小巨人企业标志（0-否，1-是）
         ,STRATEGICEMERGINGINDUSTRYTYPE --战略性新兴产业类型
         ,TRANSFORMATIONANDUPGRADEID    --工业企业技术改造升级标志（0-否，1-是）
         ,EFFECTDATE                    --合同签订日期
         ,STATISTICSTOTALBALANCE        --统计用敞口余额
         ,TRANSFORMTIMES                --变更次数
         ,BELONGITEM                    --所属项下
         ,USEEXPOSURETYPE               --占用敞口类型(UseExposureType)
         ,ISGXTECHENT                   --高新技术企业标志
         ,ISSCITECHENT                  --科技型企业
         ,ISKCTECHENT                   --科创企业
         ,ISXXDQUOTA                    --是否营销额度（新兴贷专用）
         ,ISPENSIONINDUSTRY             --养老产业标识
         ,IFSEEDLOAN                    --种业振兴贷款
         ,IFCOUNTYLOAN                  --县城区贷款
         ,IFHIGHINDUSTRY                --是否投向高技术产业
         ,NUMBERECONOMYTYPE             --投向数字经济核心产业类型
         ,RISKAPPROVEAMOUT              --风控审批可用金额
         ,ICMSAPPROVEAMOUT              --信贷审批可用金额
         ,IFCAPPROVEAMOUNT              --审批后额度合同金额（IFC专用）
         ,IFCAPPROVEBALANCE             --数总审批可用金额（IFC专用）
         ,ISSIGNEDCONTRACT              --是否签订额度合同
         ,WHETHERTORESTRUCTURETHELOAN   --是否重组贷款
         ,BDSERIALNO                    --借据号
         ,RENEWSTARTDATE                --展期起始日
         ,SECONDPAYACCOUNT              --第二还款账号
         ,MERCHORDERNUM                 --订单号
         ,APPLYNO                       --房抵贷贷款申请编号
         ,PCLNOMINALAMOUNT              --华兴易贷担保可用金额
         ,PCLOCCUPYAMOUNT               --华兴易贷担保占用金额
         ,COMTICKETRECOURSEFLAG         --商票保贴追索标识（0-否，1-是）
         ,BIZCONTRWTHRDISCTPERS         --是否贴现人保证金账户（0-否，1-是）
         ,SUBPRODUCTNAME                --子产品名称
         ,START_DT                      --开始时间
         ,END_DT                        --结束时间
         ,ID_MARK                       --增删标志
         ,ETL_TIMESTAMP                 --ETL处理时间戳
         ,RENEWALTYPE                   --展期类型   ADD BY YJY 20260318
     )
  SELECT /*+PARALLEL*/
       SERIALNO                      --合同编号
         ,BAPSERIALNO                   --批复编号
         ,RELACONTRACTNO                --关联合同编号
         ,ARTIFICIALNO                  --文本合同编号
         ,CUSTOMERID                    --客户编号
         ,CUSTOMERNAME                  --客户名称
         ,BUSINESSFLAG                  --额度/业务标志
         ,OLDCONTRACTNO                 --关联的旧合同号
         ,APPLYTYPE                     --申请类型
         ,OCCURTYPE                     --贷款发放类型
         ,OCCURDATE                     --签订日期
         ,CURRENCY                      --额度/业务币种
         ,BUSINESSSUM                   --合同金额
         ,PUTOUTSUM                     --实际放款金额
         ,PUTOUTDATE                    --放款日期
         ,BASEPRODUCT                   --基础产品(额度)基础产品
         ,PRODUCTID                     --产品编号
         ,POLICYID                      --产品政策编号
         ,POLICYVERSIONID               --产品政策版本编号
         ,PRODUCTCLASSIFY               --产品所属大类
         ,TERMMONTH                     --期限(月)
         ,TERMDAY                       --期限(天)
         ,STARTDATE                     --合同开始日期
         ,MATURITY                      --合同到期日期
         ,ISCYCLE                       --是否循环(额度)是否循环
         ,RISKTYPE                      --风险类型(额度)风险类型（一般、低风险）
         ,ISLOWRISK                     --是否低风险业务
         ,ISREMOTEBUSINESS              --是否异地业务
         ,RATEMODEL                     --利率模式利率模式(1固定利率2浮动利率3组合利率)
         ,FIXEDRATE                     --固定利率
         ,BASERATETYPE                  --基准利率类型
         ,BASERATE                      --基准利率
         ,RATEFLOATTYPE                 --利率浮动方式
         ,RATEADJUSTTYPE                --利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
         ,FLOATRANGE                    --浮动幅度
         ,EXECUTERATE                   --执行利率
         ,VOUCHTYPE                     --主担保方式
         ,HAVEADDITIONALVOUCH           --有无追加担保方式
         ,OTHERVOUCHTYPE                --其他担保方式
         ,ADDITIONCOMMAND               --其他条件和要求
         ,REPAYTYPE                     --还款方式码值为：repaytype
         ,REPAYCYCLE                    --还款周期还款周期(1月2季3一次4半年5年6双月)
         ,REPAYDATE                     --指定还款日
         ,SETTLEMENTACCOUNT             --结算账号
         ,PAYMENTTYPE                   --支付方式
         ,CREDITINVEST                  --授信投向授信投向(01绿色贷款02两高一剩（可多选）03PPP贷款)
         ,NATIONALINDUSTRYTYPE          --贷款投向行业
         ,INTRAINDUSTRYTYPE             --行内行业投向
         ,PURPOSE                       --用途
         ,RESERVESUM                    --预留金额
         ,BALANCE                       --合同贷款余额
         ,NORMALBALANCE                 --正常余额
         ,OVERDUEBALANCE                --逾期/垫款金额
         ,DULLBALANCE                   --呆滞余额
         ,BADBALANCE                    --呆账余额
         ,INNERINTERESTBALANCE          --表内欠息余额
         ,OUTERINTERESTBALANCE          --表外欠息余额
         ,CAPITALPENALTYBALANCE         --逾期罚息余额
         ,INTERESTPENALTYBALANCE        --复息余额
         ,OVERDUEDAYS                   --贷款逾期天数
         ,OWNINTERESTDAYS               --欠息天数
         ,GRACEPERIOD                   --贷款宽限期
         ,CANCELSUM                     --核销本金
         ,CANCELINTEREST                --核销利息
         ,PREDICTLOSTSUM                --预测损失金额
         ,REDUCERESERVESUM              --计提准备金额
         ,BADCONFIRMDATE                --首次认定不良日期
         ,CLASSIFYRESULT                --贷款五级分类
         ,CLASSIFYDATE                  --风险分类日期
         ,STATUS                        --合同状态
         ,FINISHDATE                    --终结日期
         ,FINISHTYPE                    --终结类型
         ,FINISHFLAG                    --结清标志
         ,CONTRACTTYPE                  --合同类型合同类型(一般合同/虚拟合同)
         ,OFFSHEETFLAG                  --表内外标志
         ,BELONGDEPT                    --所属条线BelongDept
         ,COMPLETEFLAG                  --数据录入完整性标识
         ,FLOWTYPE                      --流程类型
         ,APPROVESTATUS                 --审批状态
         ,CLNO                          --额度编号
         ,CLEFFECTSTATUS                --额度续作状态
         ,REMARK                        --备注
         ,OPERATEUSERID                 --业务经办人编号
         ,OPERATEORGID                  --经办机构
         ,OPERATEDATE                   --经办日期
         ,INPUTUSERID                   --登记人
         ,INPUTORGID                    --登记机构
         ,INPUTDATE                     --登记日期
         ,UPDATEUSERID                  --更新人
         ,UPDATEORGID                   --更新机构
         ,UPDATEDATE                    --更新日期
         ,REINFORCEFLAG                 --补充标志
         ,CORPORGID                     --法人机构编号
         ,PAYFREQUENCYUNIT              --指定周期单位
         ,PAYFREQUENCY                  --指定周期
         ,RENEWTERMDATE                 --展期前到期日
         ,RENEWTOTALSUM                 --展期前金额
         ,RENEWEXECUTEYEARRATE          --展期前执行年利率
         ,ISBANKREL                     --是否我行关联方标志
         ,VOUCHTYPE3                    --主要担保方式3
         ,VOUCHTYPE2                    --主要担保方式2
         ,LOANUSETYPE                   --贷款用途
         ,TOTALSUM                      --额度敞口金额
         ,OUTSTNDLMT                    --已占用额度
         ,BAILRATIO                     --保证金比例（%）
         ,BAILSUM                       --保证金金额
         ,TOTALBALANCE                  --敞口余额(元)
         ,CREDITAGGREEMENT              --额度协议流水号
         ,VOUCHTYPEINNER                --担保方式（内部口径）
         ,EXECUTEMONTHRATE              --执行月利率
         ,CLASSIFYRESULTELEVEN          --风险分类结果（11级）
         ,PIGEONHOLEDATE                --归档日期
         ,FREEZEFLAG                    --冻结标志
         ,RATEADJUSTFREQUENCY           --利率调整周期
         ,OVERDUERATE                   --逾期执行利率
         ,OVERDUERATEFLOATTYPE          --逾期利率浮动方式
         ,OVERDUERATEFLOATVALUE         --逾期利率浮动值
         ,PUTOUTORGID                   --出账机构编号(核心机构)
         ,SETTLEMENTACCOUNTNAME         --结算账户(还款账户)名
         ,LOANACCOUNTNO                 --入账账户
         ,LOANACCOUNTNAME               --贷款入账(收款账户)账户名
         ,LOANACCOUNTORGID              --贷款入账(收款账户)账户开户机构
         ,BAILCURRENCY                  --保证金币种
         ,BAILACCOUNT                   --保证金帐号
         ,BAILTRANSACCOUNT              --保证金转出账号
         ,MIGTFLAG                      --迁移标志：crs rcr ilc upl
         ,MANAGEUSERID                  --贷后管理人员
         ,MANAGEORGID                   --贷后管理机构
         ,ISPAGERCONTRACT               --是否签署纸质合同
         ,ISOCCUPYCREDIT                --是否占用他用额度
         ,OCCUPYCREDITBAPSERIALNO       --他用额度批复流水号
         ,OCCUPYCREDITTYPE              --他用额度类型
         ,REMART                        --计量标记
         ,CREDITAUTHNO                  --征信授权影像流水号
         ,ISQUERYCREDITREPORT           --是否自动查询贷后报告
         ,AUTHOSTRDATE                  --授权起始日
         ,ISONLINEBUSINESS              --是否线上业务：yes-是no/空-否
         ,OLDSTATUS                     --备份生效标志
         ,OLDCREDITAGGREEMENT           --使用授信协议号(备份额度合同流水号)
         ,MIGTCUSTOMERID                --转换前客户号
         ,MIGTBUSINESSTYPE              --转换前产品ID
         ,MIGTOLDVALUE                  --迁移数据-参数转换前字段值
         ,CONTRACTNOBEFOREEXTEND        --展期前合同
         ,PDGRATIO                      --手续费比率
         ,PDGSUM                        --手续费金额
         ,TEMPLETEURL                   --同业模板页面路径
         ,TEMPLETENO                    --同业模板编号
         ,VOUCHFLAG                     --有无其他担保方式，HaveNot
         ,RATEFLOATRATIOORBP            --利率浮动类型（1-按比例2-按点差）
         ,ADVANCEDMANUFLAG              --先进制造业标志（0-否，1-是）
         ,CULTUREINDUSTRYFLAG           --文化产业标志（0-否，1-是）
         ,ONLYNEWENTFLAG                --专精特新中小企业标志（0-否，1-是）
         ,ONLYNEWSMALLENTFLAG           --专精特新小巨人企业标志（0-否，1-是）
         ,STRATEGICEMERGINGINDUSTRYTYPE --战略性新兴产业类型
         ,TRANSFORMATIONANDUPGRADEID    --工业企业技术改造升级标志（0-否，1-是）
         ,EFFECTDATE                    --合同签订日期
         ,STATISTICSTOTALBALANCE        --统计用敞口余额
         ,TRANSFORMTIMES                --变更次数
         ,BELONGITEM                    --所属项下
         ,USEEXPOSURETYPE               --占用敞口类型(UseExposureType)
         ,ISGXTECHENT                   --高新技术企业标志
         ,ISSCITECHENT                  --科技型企业
         ,ISKCTECHENT                   --科创企业
         ,ISXXDQUOTA                    --是否营销额度（新兴贷专用）
         ,ISPENSIONINDUSTRY             --养老产业标识
         ,IFSEEDLOAN                    --种业振兴贷款
         ,IFCOUNTYLOAN                  --县城区贷款
         ,IFHIGHINDUSTRY                --是否投向高技术产业
         ,NUMBERECONOMYTYPE             --投向数字经济核心产业类型
         ,RISKAPPROVEAMOUT              --风控审批可用金额
         ,ICMSAPPROVEAMOUT              --信贷审批可用金额
         ,IFCAPPROVEAMOUNT              --审批后额度合同金额（IFC专用）
         ,IFCAPPROVEBALANCE             --数总审批可用金额（IFC专用）
         ,ISSIGNEDCONTRACT              --是否签订额度合同
         ,WHETHERTORESTRUCTURETHELOAN   --是否重组贷款
         ,BDSERIALNO                    --借据号
         ,RENEWSTARTDATE                --展期起始日
         ,SECONDPAYACCOUNT              --第二还款账号
         ,MERCHORDERNUM                 --订单号
         ,APPLYNO                       --房抵贷贷款申请编号
         ,PCLNOMINALAMOUNT              --华兴易贷担保可用金额
         ,PCLOCCUPYAMOUNT               --华兴易贷担保占用金额
         ,COMTICKETRECOURSEFLAG         --商票保贴追索标识（0-否，1-是）
         ,BIZCONTRWTHRDISCTPERS         --是否贴现人保证金账户（0-否，1-是）
         ,SUBPRODUCTNAME                --子产品名称
         ,START_DT                      --开始时间
         ,END_DT                        --结束时间
         ,ID_MARK                       --增删标志
         ,ETL_TIMESTAMP                 --ETL处理时间戳
         ,RENEWALTYPE                   --展期类型   ADD BY YJY 20260318
    FROM IOL.V_ICMS_BUSINESS_CONTRACT   --合同信息表_视图
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, ‘, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序跑批结束记录 --
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_O_IOL_ICMS_BUSINESS_CONTRACT;
/

