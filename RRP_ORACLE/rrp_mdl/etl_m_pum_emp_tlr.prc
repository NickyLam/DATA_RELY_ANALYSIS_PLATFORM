CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_PUM_EMP_TLR(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_PUM_EMP_TLR
  *  功能描述：监管集市柜员信息包含实体柜员和虚拟柜员
  *  创建日期：20220519
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_INTNAL_ORG_INFO --内部机构信息
  *            ICL.CMM_CLERK_INFO   --行员信息表
  *            ICL.CMM_TELLER_INFO  --柜员信息表
  *            IOL.ISBS_USR   --用户信息
  *            IOL.DPSS_TLP_TELLER --柜员参数表
  *  目标表：  M_PUM_EMP_TLR  --柜员表
  *
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221010  hulj     调整柜员类型取数逻辑。
  *             2    20221108  hulj     增加数据重复校验 。
  *             3    20221112  LHQ      修改员工编号，柜员状态取值。
  *             4    20221130  hulj     调整是否实体柜员口径。
  *             5    20230424  XXB      新增日期条件
  *             6    20251121  LAL      新增柜员姓名及取数逻辑
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_PUM_EMP_TLR'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_TAB_NAME  VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  --V_LAST_DAT  VARCHAR2(8); -- 当月月末
  --V_YESTADAY  VARCHAR2(8); -- 上日

BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_PUM_EMP_TLR'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '柜员表:逻辑1-核心系统';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_PUM_EMP_TLR
    (DATA_DT          --数据日期
    ,LGL_REP_ID       --法人编号
    ,TLR_NO           --柜员号
    ,EMP_ID           --员工编号
    ,ORG_ID           --机构编号
    ,TLR_TYP          --柜员类型
    ,ENT_TLR_FLG      --实体柜员标志
    ,POST_ID          --岗位编号
    ,TLR_AUTH_LVL     --柜员权限级别
    ,ON_DUTY_DT       --上岗日期
    ,TLR_STAT         --柜员状态
    ,DEPT_LINE        --部门条线
    ,DATA_SRC         --数据来源
    ,TELLER_STATUS_CD --柜员状态代码
    ,TLR_NAME         --柜员名称      ADD BY LAL 20251121
    )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')           AS DATA_DT       --数据日期
        ,A.LP_ID                                AS LGL_REP_ID    --法人编号
        ,A.TELLER_ID                            AS TLR_NO        --柜员号
        ,A.TELLER_ID                            AS EMP_ID        --员工编号
        ,A.BELONG_ORG_ID                        AS ORG_ID        --机构编号
        ,CASE WHEN A.TELLER_TYPE_SUBCLASS_CD = '01' THEN '普通柜员'
              WHEN A.TELLER_TYPE_SUBCLASS_CD = '02' THEN 'CRS虚拟柜员'
              WHEN A.TELLER_TYPE_SUBCLASS_CD = '03' THEN 'ATM虚拟柜员'
              WHEN A.TELLER_TYPE_SUBCLASS_CD = '04' THEN 'POS虚拟柜员'
              WHEN A.TELLER_TYPE_SUBCLASS_CD = '05' THEN 'BSM虚拟柜员'
              WHEN A.TELLER_TYPE_SUBCLASS_CD = '06' THEN '查询终端虚拟柜员'
              WHEN A.TELLER_TYPE_SUBCLASS_CD = '07' THEN 'STM虚拟柜员'
              WHEN A.TELLER_TYPE_SUBCLASS_CD = '08' THEN '清机公司柜员' --modify by tangan at 20230110 核心确定08-清机公司柜员,邮件“柜员类型-08码值映射问题”
              WHEN A.TELLER_TYPE_SUBCLASS_CD = '09' THEN '其他-其他' --modify by tangan at 20230106 根据邮件“关于新一代EAST柜员表缺陷（BUG_067290）问题”调整
          END                                  AS TLR_TYP       --柜员类型 --20221018 MW
        ,CASE WHEN  A.TELLER_TYPE_CD = 'DUMMY_TELLER'
              THEN 'N' ELSE 'Y'
          END                                  AS ENT_TLR_FLG   --实体柜员标志 mod by hulj 20221130
        ,A.JOBS_CD                             AS POST_ID       --岗位编号
        ,A.TELLER_PRVLG_LEV_CD                 AS TLR_AUTH_LVL  --柜员权限级别
        ,TO_CHAR(A.EMPYT_DT,'YYYYMMDD')        AS ON_DUTY_DT    --上岗日期 mod by hulj 20221203
        ,CASE WHEN A.TELLER_TYPE_CD = 'DUMMY_TELLER' THEN '04' ---MODIFY BY CAIZHENGWEI 20220609 特殊柜员处理
              WHEN A.TELLER_STATUS_CD IN ('A','U','O') AND C.EMPLY_TYPE_CD IN ('1','2')  THEN '02'   --正式员工在职    modify BY LHQ 20221112
              --mod by lip 20231011 增加外包人员的状态判断
              WHEN A.TELLER_STATUS_CD IN ('A','U','O') AND C.EMPLY_TYPE_CD IN ('3','4','5','6','7','8') THEN '04'    --非正式员工在职   modify BY LHQ 20221112
              ELSE '09'
          END                                   AS TLR_STAT      --柜员状态
        ,'800001'                               AS DEPT_LINE     --部门条线/*营运管理部 */
        ,'柜员信息'                             AS DATA_SRC      --数据来源
        ,A.TELLER_STATUS_CD                     AS TELLER_STATUS_CD --柜员状态代码 ADD BY HLJ 20221203
        ,A.TELLER_NAME                          AS TLR_NAME         --柜员名称     ADD BY LAL 20251121
    FROM RRP_MDL.O_ICL_CMM_TELLER_INFO A --柜员信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_CLERK_INFO  C --行员信息表
      ON C.TELLER_ID = A.TELLER_ID
     AND TRIM(C.TELLER_ID) IS NOT NULL
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE TRIM(A.TELLER_ID) IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  --记录正常日志
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);  

  --去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, TLR_NO,EMP_ID,COUNT(1)
      FROM RRP_MDL.M_PUM_EMP_TLR T
     WHERE DATA_DT = V_P_DATE
     GROUP BY DATA_DT, TLR_NO,EMP_ID
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_PUM_EMP_TLR;
/

