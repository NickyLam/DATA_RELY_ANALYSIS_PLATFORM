CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_FAMS_REP_ASSET_POSITION (I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_FAMS_REP_ASSET_POSITION
  *  功能描述：报表单据-账户持仓表
  *  创建日期：20231008
  *  开发人员：hulj
  *  来源表： IOL.V_FAMS_REP_ASSET_POSITION
  *  目标表： O_IOL_FAMS_REP_ASSET_POSITION
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20231008  hulj     首次创建
  *             2    20250106  YJY      优化脚本
  **************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_FAMS_REP_ASSET_POSITION'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  
  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM O_IOL_FAMS_REP_ASSET_POSITION  T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_FAMS_REP_ASSET_POSITION ';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-报表单据-账户持仓表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_FAMS_REP_ASSET_POSITION
  (
         CDATE                  --日期
         ,ASSETCODE             --资产代码
         ,ASSETNAME             --资产名称
         ,VDATE                 --首期日
         ,MDATE                 --到期日
         ,CUSTRATE              --利率(%)
         ,BASIS                 --计息基础 枚举值数据字典：BASIS
         ,POSITION              --持仓余额
         ,CRICEAMT              --资产价值
         ,TDYLOSSAMT            --资产减值金额
         ,UNPAYAMT              --应收利息
         ,FRICEAMT              --资产全价
         ,SPPIACTMDATE          --实际到期日
         ,ACCOUNTTYPE           --账户类型 枚举值数据字典：AMT_INCOME_TYPE
         ,ASSETTYPE             --资产类别 枚举值数据字典：FINPROD_TYPE_TG
         ,DETAILASSETTYPE       --明细资产类别
         ,PROFITTYPE            --收益类型
         ,ASSETTYPEONE          --资产分类（一级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_ONE
         ,ASSETTYPETWO          --资产分类（二级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_TWO
         ,ASSETTYPETHREE        --资产分类（三级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_THREE
         ,ASSETTYPEFOUR         --资产分类（四级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_FOUR
         ,ASSETTYPESECONE       --资产分类（债券品种维度一级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_SEC_ONE
         ,ASSETTYPESECTWO       --资产分类（债券品种维度二级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_SEC_TWO
         ,ASSETTYPEISSUEONE     --资产分类（发行主体维度）枚举值数据字典：ASSET_TYPE_MAINTENANCE_ISSUE_ONE
         ,MAINGRADE             --债券主体评级 枚举值数据字典：MAIN_GRADE_RESULT
         ,MAINGRADEORG          --主体评级机构 枚举值数据字典：GRADE_PARTY
         ,CREDITGRADE           --债券信用评级 枚举值数据字典：MAIN_GRADE_RESULT
         ,CREDITGRADEORG        --债券评级机构 枚举值数据字典：GRADE_PARTY
         ,TERMTYPE              --剩余期限分类
         ,INVESTNATURE          --资产投资性质 枚举值数据字典：INVEST_TYPE
         ,ISSTANDASSET          --是否标准化资产
         ,INVESTMENTTYPE        --投资方式 枚举值数据字典：INVESTMENT_TYPE
         ,CUSTOMERNAME          --基础资产客户名称
         ,CREATE_USER           --创建人
         ,CREATE_DEPT           --创建部门
         ,CREATE_TIME           --创建时间
         ,UPDATE_USER           --更新人
         ,UPDATE_TIME           --更新时间
         ,START_DT              --开始时间
         ,END_DT                --结束时间
         ,ID_MARK               --增删标志
    )
    SELECT
         CDATE                  --日期
         ,ASSETCODE             --资产代码
         ,ASSETNAME             --资产名称
         ,VDATE                 --首期日
         ,MDATE                 --到期日
         ,CUSTRATE              --利率(%)
         ,BASIS                 --计息基础 枚举值数据字典：BASIS
         ,POSITION              --持仓余额
         ,CRICEAMT              --资产价值
         ,TDYLOSSAMT            --资产减值金额
         ,UNPAYAMT              --应收利息
         ,FRICEAMT              --资产全价
         ,SPPIACTMDATE          --实际到期日
         ,ACCOUNTTYPE           --账户类型 枚举值数据字典：AMT_INCOME_TYPE
         ,ASSETTYPE             --资产类别 枚举值数据字典：FINPROD_TYPE_TG
         ,DETAILASSETTYPE       --明细资产类别
         ,PROFITTYPE            --收益类型
         ,ASSETTYPEONE          --资产分类（一级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_ONE
         ,ASSETTYPETWO          --资产分类（二级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_TWO
         ,ASSETTYPETHREE        --资产分类（三级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_THREE
         ,ASSETTYPEFOUR         --资产分类（四级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_FOUR
         ,ASSETTYPESECONE       --资产分类（债券品种维度一级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_SEC_ONE
         ,ASSETTYPESECTWO       --资产分类（债券品种维度二级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_SEC_TWO
         ,ASSETTYPEISSUEONE     --资产分类（发行主体维度）枚举值数据字典：ASSET_TYPE_MAINTENANCE_ISSUE_ONE
         ,MAINGRADE             --债券主体评级 枚举值数据字典：MAIN_GRADE_RESULT
         ,MAINGRADEORG          --主体评级机构 枚举值数据字典：GRADE_PARTY
         ,CREDITGRADE           --债券信用评级 枚举值数据字典：MAIN_GRADE_RESULT
         ,CREDITGRADEORG        --债券评级机构 枚举值数据字典：GRADE_PARTY
         ,TERMTYPE              --剩余期限分类
         ,INVESTNATURE          --资产投资性质 枚举值数据字典：INVEST_TYPE
         ,ISSTANDASSET          --是否标准化资产
         ,INVESTMENTTYPE        --投资方式 枚举值数据字典：INVESTMENT_TYPE
         ,CUSTOMERNAME          --基础资产客户名称
         ,CREATE_USER           --创建人
         ,CREATE_DEPT           --创建部门
         ,CREATE_TIME           --创建时间
         ,UPDATE_USER           --更新人
         ,UPDATE_TIME           --更新时间
         ,START_DT              --开始时间
         ,END_DT                --结束时间
         ,ID_MARK               --增删标志
    FROM IOL.V_FAMS_REP_ASSET_POSITION --报表单据-账户持仓表
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

  END ETL_O_IOL_FAMS_REP_ASSET_POSITION ;
/

