CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_CLR_VALUE_HISTORY(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：押品价值历史信息表
  **存储过程名称：    ETL_O_IOL_ICMS_CLR_VALUE_HISTORY
  **存储过程创建日期：20260112
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20260112    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_ICMS_CLR_VALUE_HISTORY'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_CLR_VALUE_HISTORY';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-押品价值历史信息表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ICMS_CLR_VALUE_HISTORY NOLOGGING 
  (          SERIALNO                --价值记录流水号
             ,CLRID                  --押品编号
             ,EVALMODE               --评估方式（01-外部评估、02-内部评估、03-内外部综合评估）
             ,EVALDATE               --估值日期
             ,CURRENY                --币种
             ,RATE                   --汇率
             ,OUTEVALEXPDATE         --外部评估价值估值到期日期
             ,OUTEVALDEPTCODE        --外部评估机构
             ,OUTEVALMETHOD          --外部评估方法（01-指数法_外部指数、02-指数法_内部构建指数、03-市场法、04-收益法、05-重置成本法、06-工程进度法、07-非上市公司股权净资产比例法、08-直接引用法_金融质抵质押品、09-直接引用法_动产、10-直接引用法_房地产、11-直接引用法_询价、12-其他）
             ,OUTEVALFLAG            --是否有外部预评估报告（0-否、1-是）
             ,OUTEVALAMT1            --外部预评估报告的评估价值
             ,OUTEVALDATE            --外部正式评估报告评估日期
             ,OUTEVALAMT             --外部正式评估报告的评估价值
             ,EVALAMT                --内部评估价值
             ,EVALAMT2               --申请评估确认价值
             ,BUSINESSINSID          --流程编号（我行确认价值对应的流程编号，如我行确认价值为自动重估得到，则该字段为空）
             ,CONFMAMT               --我行确认价值
             ,CONDATE                --评估认定日期
             ,FIRSTOUTEVALAMT        --初评外部正式评估价值
             ,FIRSTEVALAMT           --初评内部评估价值
             ,FIRSTCONFMAMT          --初评我行确认价值
             ,STARTBUSINESSINSID     --初评流程编号
             ,VERECOGINITION         --押品价值认定方式
             ,OUTEVALSTATUS          --准入状态（01-未准入、02-已准入、03-黑名单、04-已退出、05-已取消）
             ,OUTEVALEXTCUSTCNAME    --外部评估机构名称
             ,SLFLAG                 --是否世联评估
             ,ISACCURATEPRICE        --是否精准价(1是【按照楼盘id+楼栋id+房号编码+面积，世联返回的价格】 0否【世联返回均价】
             ,MIGTFLAG               --迁移标识：rs rcr ilc upl mim
             ,AUTOOUTEVALAMT         --世联评估价值
             ,AUTOOUTEVALAMT2        --房讯通评估价值
             ,OUTEVALDEPTCODE2       --外部评估机构2
             ,OUTEVALAMT2            --外部正式评估报告的评估价值2
             ,OUTEVALDATE2           --外部评估基准日2
             ,OUTEVALFLAG2           --是否有外部评估报告2
             ,OUTEVALSTARTDATE2      --外部评估价值有效期起始日2
             ,OUTEVALEXPDATE2        --外部评估价值有效期截止日2
             ,CONFMDEPTCODE          --最终选定外部评估机构
             ,CALCULATEFLAG          --测算标识
             ,ACCOUTINGAMT           --记账价值
             ,ACCOUTINGORGID         --记账机构
             ,OUTEVALSTARTDATE       --外部评估价值有效期起始日
             ,ISVALUECHANGE          --是否变更我行确认价值
             ,SLCASEID               --世联估值案例编号
             ,FXTCASEID              --房讯通估值案例编号
             ,START_DT               --开始时间
             ,END_DT                 --结束时间
             ,ID_MARK                --增删标志
             ,ETL_TIMESTAMP          --ETL处理时间戳
       )
     SELECT 
             SERIALNO                --价值记录流水号
             ,CLRID                  --押品编号
             ,EVALMODE               --评估方式（01-外部评估、02-内部评估、03-内外部综合评估）
             ,EVALDATE               --估值日期
             ,CURRENY                --币种
             ,RATE                   --汇率
             ,OUTEVALEXPDATE         --外部评估价值估值到期日期
             ,OUTEVALDEPTCODE        --外部评估机构
             ,OUTEVALMETHOD          --外部评估方法（01-指数法_外部指数、02-指数法_内部构建指数、03-市场法、04-收益法、05-重置成本法、06-工程进度法、07-非上市公司股权净资产比例法、08-直接引用法_金融质抵质押品、09-直接引用法_动产、10-直接引用法_房地产、11-直接引用法_询价、12-其他）
             ,OUTEVALFLAG            --是否有外部预评估报告（0-否、1-是）
             ,OUTEVALAMT1            --外部预评估报告的评估价值
             ,OUTEVALDATE            --外部正式评估报告评估日期
             ,OUTEVALAMT             --外部正式评估报告的评估价值
             ,EVALAMT                --内部评估价值
             ,EVALAMT2               --申请评估确认价值
             ,BUSINESSINSID          --流程编号（我行确认价值对应的流程编号，如我行确认价值为自动重估得到，则该字段为空）
             ,CONFMAMT               --我行确认价值
             ,CONDATE                --评估认定日期
             ,FIRSTOUTEVALAMT        --初评外部正式评估价值
             ,FIRSTEVALAMT           --初评内部评估价值
             ,FIRSTCONFMAMT          --初评我行确认价值
             ,STARTBUSINESSINSID     --初评流程编号
             ,VERECOGINITION         --押品价值认定方式
             ,OUTEVALSTATUS          --准入状态（01-未准入、02-已准入、03-黑名单、04-已退出、05-已取消）
             ,OUTEVALEXTCUSTCNAME    --外部评估机构名称
             ,SLFLAG                 --是否世联评估
             ,ISACCURATEPRICE        --是否精准价(1是【按照楼盘id+楼栋id+房号编码+面积，世联返回的价格】 0否【世联返回均价】
             ,MIGTFLAG               --迁移标识：rs rcr ilc upl mim
             ,AUTOOUTEVALAMT         --世联评估价值
             ,AUTOOUTEVALAMT2        --房讯通评估价值
             ,OUTEVALDEPTCODE2       --外部评估机构2
             ,OUTEVALAMT2            --外部正式评估报告的评估价值2
             ,OUTEVALDATE2           --外部评估基准日2
             ,OUTEVALFLAG2           --是否有外部评估报告2
             ,OUTEVALSTARTDATE2      --外部评估价值有效期起始日2
             ,OUTEVALEXPDATE2        --外部评估价值有效期截止日2
             ,CONFMDEPTCODE          --最终选定外部评估机构
             ,CALCULATEFLAG          --测算标识
             ,ACCOUTINGAMT           --记账价值
             ,ACCOUTINGORGID         --记账机构
             ,OUTEVALSTARTDATE       --外部评估价值有效期起始日
             ,ISVALUECHANGE          --是否变更我行确认价值
             ,SLCASEID               --世联估值案例编号
             ,FXTCASEID              --房讯通估值案例编号
             ,START_DT               --开始时间
             ,END_DT                 --结束时间
             ,ID_MARK                --增删标志
             ,ETL_TIMESTAMP          --ETL处理时间戳
    FROM IOL.V_ICMS_CLR_VALUE_HISTORY --视图-押品价值历史信息表
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
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_ICMS_CLR_VALUE_HISTORY', '', O_ERRCODE); --表分析
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

END ETL_O_IOL_ICMS_CLR_VALUE_HISTORY;
/

