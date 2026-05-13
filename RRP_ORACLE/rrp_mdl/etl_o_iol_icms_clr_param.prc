CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_CLR_PARAM(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：押品分类参数
  **存储过程名称：    ETL_O_IOL_ICMS_CLR_PARAM
  **存储过程创建日期：20251014
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20251014    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_ICMS_CLR_PARAM'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_CLR_PARAM';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-押品分类参数';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ICMS_CLR_PARAM NOLOGGING 
  (          CLRTYPEID              --押品类型编号
            ,CLRTYPENAME            --押品类型名称
            ,CRMTYPE                --风险缓释工具类型
            ,MAXLTV                 --最大抵质押率
            ,MAXLTVSCENARIO         --最大抵质押率适用业务场景
            ,ISALLOWEDMORT          --是否允许抵押
            ,ISALLOWEDPLEDGE        --是否允许质押
            ,ISALLOWEDREMORT        --是否允许重复抵押
            ,ISALLOWEDREMORTINLINE  --是否允许行内重复抵押
            ,ISACCEPTNFSTREPAY      --是否接受非第一顺位受偿
            ,REGISTAGENCYTYPE       --权利登记机关类型
            ,GNTCERTTYPE            --抵质押代表权证类型
            ,ATTTEMPLATE            --押品要素模板
            ,INFOTAB                --押品详细组合信息页面
            ,ISCURRMISMATCH         --是否允许币种错配
            ,ISNEEDINSURANCE        --是否需要投保
            ,RENEWALTERM            --续保期限;年)
            ,ISNEEDNOTARIZAITON     --是否需要公证
            ,ISNEEDRGST             --是否需要抵质押登记手续
            ,ISNEEDMONITORING       --是否需要贷后现场检查
            ,MONITORINGFRQ          --贷后现场检查频率
            ,MAXGUATERM             --最大担保期限
            ,MAXGUASCENARIO         --最大担保期限适用业务场景
            ,EVALPERIOD             --价值评估周期;月)
            ,ISSUITINEVAL           --是否适用内部评估
            ,ISSUITOUTEVAL          --是否适用外部评估
            ,MAINEVALMETHOD         --主要的估值方法
            ,DETAILEVALMODEL        --适用的详细评估模型
            ,FASTEVALMODEL          --适用的快速评估模型
            ,EVALFLOW               --价值评估流程
            ,APPRAISEATT            --外部评估公司资质要求
            ,REEVALFRQUNIT          --重估频率单位
            ,REEVALFRQ              --重估频率
            ,ISAUTOREEVAL           --是否自动重估
            ,AUTOREEVALMODE         --固定日期滚动周期
            ,REEVALDATEDEF          --重估日定义
            ,EXTWEIGHT              --外评权重
            ,INWEIGHT               --内评权重
            ,ISNEEDRIGHTCERT        --是否需要提交权证
            ,ISSUITCOMBINEEVAL      --是否适用内外结合评估
            ,ISMANUALBATCHREVAL     --是否人工批量重估
            ,ISSYSBATCHREVAL        --是否系统批量重估
            ,EVALMODELMARKET        --市场法估值模板
            ,EVALMODELPROFIT        --收益法估值模板
            ,EVALMODELCOST          --成本法估值模板
            ,EVALMODELQUICK         --贷后快速评估模板
            ,ISHAVEWARRANT          --是否有他项权证
            ,ISNEEDIN               --是否需要入库
            ,ISQUALIFIED            --是否合格缓释工具
            ,VALIDCERTTYPE          --有效权证名称
            ,INPUTORGID             --登记机构
            ,INPUTUSERID            --登记人
            ,INPUTDATE              --登记日期
            ,UPDATEORGID            --更新机构
            ,UPDATEUSERID           --更新人
            ,UPDATEDATE             --更新日期
            ,REMARK                 --备注
            ,ENTRYCRITERIA          --准入条件文本
            ,PRODUCTLIST            --适用的产品
            ,CLRONLYSCOPE           --押品唯一性校验范围
            ,MAINCERTTYPE           --主权证类型
            ,START_DT               --开始时间
            ,END_DT                 --结束时间
            ,ID_MARK                --增删标志
            ,ETL_TIMESTAMP          --ETL处理时间戳
    )
    SELECT
             CLRTYPEID              --押品类型编号
            ,CLRTYPENAME            --押品类型名称
            ,CRMTYPE                --风险缓释工具类型
            ,MAXLTV                 --最大抵质押率
            ,MAXLTVSCENARIO         --最大抵质押率适用业务场景
            ,ISALLOWEDMORT          --是否允许抵押
            ,ISALLOWEDPLEDGE        --是否允许质押
            ,ISALLOWEDREMORT        --是否允许重复抵押
            ,ISALLOWEDREMORTINLINE  --是否允许行内重复抵押
            ,ISACCEPTNFSTREPAY      --是否接受非第一顺位受偿
            ,REGISTAGENCYTYPE       --权利登记机关类型
            ,GNTCERTTYPE            --抵质押代表权证类型
            ,ATTTEMPLATE            --押品要素模板
            ,INFOTAB                --押品详细组合信息页面
            ,ISCURRMISMATCH         --是否允许币种错配
            ,ISNEEDINSURANCE        --是否需要投保
            ,RENEWALTERM            --续保期限;年)
            ,ISNEEDNOTARIZAITON     --是否需要公证
            ,ISNEEDRGST             --是否需要抵质押登记手续
            ,ISNEEDMONITORING       --是否需要贷后现场检查
            ,MONITORINGFRQ          --贷后现场检查频率
            ,MAXGUATERM             --最大担保期限
            ,MAXGUASCENARIO         --最大担保期限适用业务场景
            ,EVALPERIOD             --价值评估周期;月)
            ,ISSUITINEVAL           --是否适用内部评估
            ,ISSUITOUTEVAL          --是否适用外部评估
            ,MAINEVALMETHOD         --主要的估值方法
            ,DETAILEVALMODEL        --适用的详细评估模型
            ,FASTEVALMODEL          --适用的快速评估模型
            ,EVALFLOW               --价值评估流程
            ,APPRAISEATT            --外部评估公司资质要求
            ,REEVALFRQUNIT          --重估频率单位
            ,REEVALFRQ              --重估频率
            ,ISAUTOREEVAL           --是否自动重估
            ,AUTOREEVALMODE         --固定日期滚动周期
            ,REEVALDATEDEF          --重估日定义
            ,EXTWEIGHT              --外评权重
            ,INWEIGHT               --内评权重
            ,ISNEEDRIGHTCERT        --是否需要提交权证
            ,ISSUITCOMBINEEVAL      --是否适用内外结合评估
            ,ISMANUALBATCHREVAL     --是否人工批量重估
            ,ISSYSBATCHREVAL        --是否系统批量重估
            ,EVALMODELMARKET        --市场法估值模板
            ,EVALMODELPROFIT        --收益法估值模板
            ,EVALMODELCOST          --成本法估值模板
            ,EVALMODELQUICK         --贷后快速评估模板
            ,ISHAVEWARRANT          --是否有他项权证
            ,ISNEEDIN               --是否需要入库
            ,ISQUALIFIED            --是否合格缓释工具
            ,VALIDCERTTYPE          --有效权证名称
            ,INPUTORGID             --登记机构
            ,INPUTUSERID            --登记人
            ,INPUTDATE              --登记日期
            ,UPDATEORGID            --更新机构
            ,UPDATEUSERID           --更新人
            ,UPDATEDATE             --更新日期
            ,REMARK                 --备注
            ,ENTRYCRITERIA          --准入条件文本
            ,PRODUCTLIST            --适用的产品
            ,CLRONLYSCOPE           --押品唯一性校验范围
            ,MAINCERTTYPE           --主权证类型
            ,START_DT               --开始时间
            ,END_DT                 --结束时间
            ,ID_MARK                --增删标志
            ,ETL_TIMESTAMP          --ETL处理时间戳
  FROM IOL.V_ICMS_CLR_PARAM --视图-押品分类参数
 WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   AND ID_MARK <> 'D';
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_ICMS_CLR_PARAM', '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
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

END ETL_O_IOL_ICMS_CLR_PARAM;
/

