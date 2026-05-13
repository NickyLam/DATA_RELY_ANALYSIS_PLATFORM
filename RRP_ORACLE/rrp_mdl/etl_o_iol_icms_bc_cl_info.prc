CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_BC_CL_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：业务合同额度属性表
  **存储过程名称：    ETL_O_IOL_ICMS_BC_CL_INFO
  **存储过程创建日期：20251223
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20251223    YJY        创建  
  *****************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_ICMS_BC_CL_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_BC_CL_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-业务合同额度属性表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ICMS_BC_CL_INFO NOLOGGING 
  (          SERIALNO                --流水号
            ,LINECLASS               --额度种类综合/专项/其他)
            ,CURRENCYRANGE           --项下业务币种范围
            ,LNGOTIMES               --借新还旧次数
            ,OCCUPYNOMINALSUM        --已用名义金额自动计算)
            ,AFTERLOANUSERID         --贷后管理人员
            ,CREDITFLOWTYPE          --授信业务流程类型
            ,CREDITAREA              --授信区域
            ,APPROVALSUGGESTION      --建议审批等级
            ,USETERM                 --额度项下业务最迟到期日期
            ,FREEZEFLAG              --冻结标志
            ,BIZLONGESTTERM          --额度下业务最长期限月)
            ,OCCUPYEXPOSURESUM       --已用敞口金额自动计算)
            ,LIMITUSECONDITION       --额度使用条件
            ,CLASSIFYTYPE2           --风险暴露分类
            ,BIZEXTENDEDTERM         --额度下业务延展期限月)
            ,OUTCLASSIFYDATE         --外部评级日期
            ,TERMTYPE                --期限申请类型额度)
            ,AVAILABLENOMINALSUM     --可用名义金额
            ,AFTERLOANORGID          --贷后管理机构
            ,OUTCLASSIFYORG          --外部评级机构
            ,INVESTWAY               --投资方式
            ,BIZLOWESTFLOATRATE      --额度下业务利率最低浮动
            ,GUARANTYBAILSUBACCOUNT  --押品转保证金子户号
            ,ISRZ                    --是否融资合同
            ,ISGOVERNFINANCE         --是否涉及政府类融资
            ,ISGREENFINANCE          --是否为绿色信贷融资
            ,MAXNOMINALAMOUNT        --单一最高授信额度名义金额
            ,USEWITHOUTCONDITION     --能否直接使用额度)
            ,BUSINESSTYPE2           --专业贷款分类
            ,FUNDSOURCE              --资金来源
            ,PLAYTYPE                --参与方式
            ,BIZMOSTMORTGAGERATE     --额度下业务最高抵质押率
            ,BIZBAILINITIALRATE      --额度下业务初始保证金比例
            ,AVAILABLEEXPOSURESUM    --可用敞口金额
            ,SYNDICATETOTALSUM       --银团贷款总金额
            ,ISBELTROADFINANCE       --是否为一带一路建设投融资
            ,MIGTFLAG                --
            ,ISTRANS                 --是否转授信
            ,LINECONTROLMODE         --集团额度管控模式超额分配/全额分配)
            ,OTHERLIMITFLAG          --是否占用他用额度
            ,SINGLEBIZMOSTAMOUNT     --额度下业务单笔最大金额
            ,EXPOSURESUM             --额度敞口金额
            ,PUTOUTORGID             --放贷机构
            ,RISKEXPOSURESUM         --其中，一般风险敞口金额(元)
            ,ISQUERYCREDITREPORT     --是否自动查询贷后报告
            ,ONLINEAMOUNT            --线上额度(元)
            ,ISCONSUMERFINANCE       --是否为消费服务类融资
            ,MAXEXPOSUREAMOUNT       --单一最高授信额度敞口金额
            ,ISPUBLICCREDIT          --是否公开授信额度)
            ,CREDITAUTHNO            --征信授权影像流水号
            ,ISLIKELOAN              --是否类信贷
            ,LOWRISKEXPOSURESUM      --其中，类低风险敞口金额(元)
            ,DRTIMES                 --债务重组次数
            ,GUARANTYBAILACCOUNT     --押品转保证金账号
            ,NOMINALSUM              --额度名义金额
            ,LATESTUSEDATE           --额度最迟使用日期
            ,OUTCLASSIFYLEVEL        --外部债项评级
            ,ISESTATEFINANCE         --是否涉及房地产融资
            ,NOEFFECTREASON          --失效原因
            ,CHANGETYPE              --变更原因
            ,HXTYOPERATEORG          --归口管理部门
            ,CLASSIFYRESULTELEVEN    --债项分类
            ,ISCREDITINCREMENT       --是否有增信
            ,HXTYMAINRATELEVEL       --外部主体评级
            ,MAINLEVELORG            --主体评级机构
            ,MAINLEVELDATE           --主体评级日期
            ,PURPOSE                 --资金用途
            ,INVESTTARGET            --投资标的
            ,PUBLICORG               --发行场所
            ,APPROVEPUBSUM           --批准发行总额
            ,PUBLISHSUM              --本次发行金额
            ,ISSUERNAME              --发行人名称
            ,ISSUERID                --发行人编号
            ,ORIGINALNAME            --原始权益人名称
            ,ORIGINALID              --原始权益人编号
            ,CHANNELNAME             --通道方名称
            ,CHANNELID               --通道方编号
            ,MANAGENAME              --管理人名称
            ,MANAGEID                --管理人客户号
            ,ISPENETRATE             --是否可穿透
            ,MONEYINDUSTRYT          --资金投向行业
            ,SUPPLYCHAIN             --供应链业务单占核心企业额度
            ,ISLIKELOWRISK           --是否类低风险
            ,FOCUSLENDTYPE           --集中放款业务类型
            ,ISINNOVATE              --是否创新业务
            ,ISSUPPLYCHAINFINANCE    --是否供应链金融业务
            ,LMTTYP                  --同业额度合同-额度类型
            ,SQDKZE      
            ,ISJOINLIMITS      
            ,OTHERLIMITAMOUNT      
            ,ISCOLLECTIONAGENCY      
            ,ISLIMIT      
            ,START_DT                --开始时间
            ,END_DT                  --结束时间
            ,ID_MARK                 --增删标志
            ,ETL_TIMESTAMP           --ETL处理时间戳
    )
  SELECT 
           SERIALNO                --流水号
            ,LINECLASS               --额度种类综合/专项/其他)
            ,CURRENCYRANGE           --项下业务币种范围
            ,LNGOTIMES               --借新还旧次数
            ,OCCUPYNOMINALSUM        --已用名义金额自动计算)
            ,AFTERLOANUSERID         --贷后管理人员
            ,CREDITFLOWTYPE          --授信业务流程类型
            ,CREDITAREA              --授信区域
            ,APPROVALSUGGESTION      --建议审批等级
            ,USETERM                 --额度项下业务最迟到期日期
            ,FREEZEFLAG              --冻结标志
            ,BIZLONGESTTERM          --额度下业务最长期限月)
            ,OCCUPYEXPOSURESUM       --已用敞口金额自动计算)
            ,LIMITUSECONDITION       --额度使用条件
            ,CLASSIFYTYPE2           --风险暴露分类
            ,BIZEXTENDEDTERM         --额度下业务延展期限月)
            ,OUTCLASSIFYDATE         --外部评级日期
            ,TERMTYPE                --期限申请类型额度)
            ,AVAILABLENOMINALSUM     --可用名义金额
            ,AFTERLOANORGID          --贷后管理机构
            ,OUTCLASSIFYORG          --外部评级机构
            ,INVESTWAY               --投资方式
            ,BIZLOWESTFLOATRATE      --额度下业务利率最低浮动
            ,GUARANTYBAILSUBACCOUNT  --押品转保证金子户号
            ,ISRZ                    --是否融资合同
            ,ISGOVERNFINANCE         --是否涉及政府类融资
            ,ISGREENFINANCE          --是否为绿色信贷融资
            ,MAXNOMINALAMOUNT        --单一最高授信额度名义金额
            ,USEWITHOUTCONDITION     --能否直接使用额度)
            ,BUSINESSTYPE2           --专业贷款分类
            ,FUNDSOURCE              --资金来源
            ,PLAYTYPE                --参与方式
            ,BIZMOSTMORTGAGERATE     --额度下业务最高抵质押率
            ,BIZBAILINITIALRATE      --额度下业务初始保证金比例
            ,AVAILABLEEXPOSURESUM    --可用敞口金额
            ,SYNDICATETOTALSUM       --银团贷款总金额
            ,ISBELTROADFINANCE       --是否为一带一路建设投融资
            ,MIGTFLAG                --
            ,ISTRANS                 --是否转授信
            ,LINECONTROLMODE         --集团额度管控模式超额分配/全额分配)
            ,OTHERLIMITFLAG          --是否占用他用额度
            ,SINGLEBIZMOSTAMOUNT     --额度下业务单笔最大金额
            ,EXPOSURESUM             --额度敞口金额
            ,PUTOUTORGID             --放贷机构
            ,RISKEXPOSURESUM         --其中，一般风险敞口金额(元)
            ,ISQUERYCREDITREPORT     --是否自动查询贷后报告
            ,ONLINEAMOUNT            --线上额度(元)
            ,ISCONSUMERFINANCE       --是否为消费服务类融资
            ,MAXEXPOSUREAMOUNT       --单一最高授信额度敞口金额
            ,ISPUBLICCREDIT          --是否公开授信额度)
            ,CREDITAUTHNO            --征信授权影像流水号
            ,ISLIKELOAN              --是否类信贷
            ,LOWRISKEXPOSURESUM      --其中，类低风险敞口金额(元)
            ,DRTIMES                 --债务重组次数
            ,GUARANTYBAILACCOUNT     --押品转保证金账号
            ,NOMINALSUM              --额度名义金额
            ,LATESTUSEDATE           --额度最迟使用日期
            ,OUTCLASSIFYLEVEL        --外部债项评级
            ,ISESTATEFINANCE         --是否涉及房地产融资
            ,NOEFFECTREASON          --失效原因
            ,CHANGETYPE              --变更原因
            ,HXTYOPERATEORG          --归口管理部门
            ,CLASSIFYRESULTELEVEN    --债项分类
            ,ISCREDITINCREMENT       --是否有增信
            ,HXTYMAINRATELEVEL       --外部主体评级
            ,MAINLEVELORG            --主体评级机构
            ,MAINLEVELDATE           --主体评级日期
            ,PURPOSE                 --资金用途
            ,INVESTTARGET            --投资标的
            ,PUBLICORG               --发行场所
            ,APPROVEPUBSUM           --批准发行总额
            ,PUBLISHSUM              --本次发行金额
            ,ISSUERNAME              --发行人名称
            ,ISSUERID                --发行人编号
            ,ORIGINALNAME            --原始权益人名称
            ,ORIGINALID              --原始权益人编号
            ,CHANNELNAME             --通道方名称
            ,CHANNELID               --通道方编号
            ,MANAGENAME              --管理人名称
            ,MANAGEID                --管理人客户号
            ,ISPENETRATE             --是否可穿透
            ,MONEYINDUSTRYT          --资金投向行业
            ,SUPPLYCHAIN             --供应链业务单占核心企业额度
            ,ISLIKELOWRISK           --是否类低风险
            ,FOCUSLENDTYPE           --集中放款业务类型
            ,ISINNOVATE              --是否创新业务
            ,ISSUPPLYCHAINFINANCE    --是否供应链金融业务
            ,LMTTYP                  --同业额度合同-额度类型
            ,SQDKZE      
            ,ISJOINLIMITS      
            ,OTHERLIMITAMOUNT      
            ,ISCOLLECTIONAGENCY      
            ,ISLIMIT      
            ,START_DT                --开始时间
            ,END_DT                  --结束时间
            ,ID_MARK                 --增删标志
            ,ETL_TIMESTAMP           --ETL处理时间戳
    FROM IOL.V_ICMS_BC_CL_INFO --视图-业务合同额度属性表
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_ICMS_BC_CL_INFO', '', O_ERRCODE); --表分析
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_ICMS_BC_CL_INFO;
/

