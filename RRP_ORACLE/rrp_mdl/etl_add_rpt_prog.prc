CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_ADD_RPT_PROG(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_ADD_RPT_PROG
  *  功能描述：监管报送进度表 取数脚本
  *  目标表  ：RRP_MDL.ETL_ADD_RPT_PROG 监管报送进度表
  *  来源表  ：RRP_MDL.ETL_ADD_RPT_PROG_ETL 监管报送进度表ETL
  *  配置表  ：不涉及
  *  创建日期：20250731
  *  开发人员：LAL
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20250731   LAL     首次创建
  *             2    20250908   LAL     补充已完成报表数量字段、修改报送情况判断逻辑
  *             3    20250925   LAL     删除数据重复校验逻辑
  ***************************************************************************/
AS
 -- 定义变量 --
 V_P_DATE    VARCHAR2(8);                          -- 跑批数据日期
 V_SYSTEM    VARCHAR2(30) := '监管报送';           -- 来源系统
 V_PROC_NAME VARCHAR2(30) := 'ETL_ADD_RPT_PROG';   -- 程序名称
 V_STARTTIME DATE;                                 -- 处理开始时间
 V_ENDTIME   DATE;                                 -- 处理结束时间
 V_STEP      INTEGER := 0;                         -- 处理步骤
 V_STEP_DESC VARCHAR2(500);                        -- 步骤描述
 V_SQLCOUNT  INTEGER;                              -- 记录数
 V_SQLMSG    VARCHAR2(500);                        -- SQL执行描述信息

BEGIN
  -- 获取跑批日期 --
  V_P_DATE := TO_CHAR(I_P_DATE);

  -- STEP1：跑批开始 --
  V_STEP := 1;
  V_STEP_DESC := '跑批开始';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- STEP2：情空历史 --
  V_STEP := V_STEP +1;
  V_STEP_DESC := '清空历史';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.ADD_RPT_PROG';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- STEP3：程序业务逻辑处理主体部分 --
  V_STEP := V_STEP +1;
  V_STEP_DESC := '目标表数据插入';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.ADD_RPT_PROG
             (RPT_SYS       -- 报送系统
              ,RPT_MODULE    -- 报送模块
              ,RPT_BATCH     -- 报送批次
              ,RPT_DEPT      -- 负责部门
              ,TECH_SUPT     -- 技术支持
              ,RPT_LATEST_TM -- 最晚报送时间
              ,RPT_ACTL_TM   -- 实际报送时间
              ,RPT_TOT_CNT   -- 报表数量
              ,CMPLTED_CNT   -- 已完成报表数量
              ,RPT_SITU      -- 报送情况
              ,REMARK        -- 备注
              ,SEQ_NUM       -- 序号
             )
        SELECT RPT_SYS       -- 报送系统
              ,RPT_MODULE    -- 报送模块
              ,RPT_BATCH     -- 报送批次
              ,RPT_DEPT      -- 负责部门
              ,TECH_SUPT     -- 技术支持
              ,RPT_LATEST_TM -- 最晚报送时间
              ,RPT_ACTL_TM   -- 实际报送时间
              ,RPT_TOT_CNT   -- 总报表数量
              ,CMPLTED_CNT   -- 已完成报表数量
              ,CASE WHEN CMPLTED_CNT = RPT_TOT_CNT THEN '已完成'
                    WHEN CMPLTED_CNT IS NOT NULL AND CMPLTED_CNT < RPT_TOT_CNT THEN '报送中'
                    ELSE '未开始'
                END AS RPT_SITU -- 报送情况
              ,REMARK        -- 备注
              ,ROW_NUMBER() OVER(ORDER BY RPT_LATEST_TM ASC) AS SEQ_NUM -- 序号
         FROM RRP_MDL.ADD_RPT_PROG_ETL
        WHERE SYS_DATA_DATE = (SELECT MAX(SYS_DATA_DATE) FROM RRP_MDL.ADD_RPT_PROG_ETL);

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- STEP4：跑批结束 --
  V_STEP := V_STEP +1;
  V_STEP_DESC := '跑批结束';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
       VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 异常处理 --
  EXCEPTION
    WHEN OTHERS THEN
      V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
      O_ERRCODE := '1';
      V_ENDTIME := SYSDATE;
      ROLLBACK;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_ADD_RPT_PROG;
/

