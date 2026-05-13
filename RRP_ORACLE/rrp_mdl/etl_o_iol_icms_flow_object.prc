CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_FLOW_OBJECT(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_ICMS_FLOW_OBJECT
  *  功能描述：流程对象表
  *  创建日期：20220619
  *  开发人员：梅炜
  *  来源表： IOL.V_ICMS_FLOW_OBJECT
  *  目标表： O_IOL_ICMS_FLOW_OBJECT
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  *             2    20241227  YJY      优化脚本
  **************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := '0'; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ICMS_FLOW_OBJECT'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM O_IOL_ICMS_FLOW_OBJECT T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_FLOW_OBJECT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-流程对象表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_ICMS_FLOW_OBJECT
  (    OBJECTTYPE                   --流程对象任务类型
			,OBJECTNO                    --流程对象编号
			,PHASETYPE                   --当前阶段类型
			,APPLYTYPE                   --申请类型
			,FLOWNO                      --流程模型编号
			,FLOWNAME                    --流程模型名称
			,PHASENO                     --当前阶段编号
			,PHASENAME                   --当前阶段名称
			,OBJDESCRIBE                 --流程描述
			,OBJATTRIBUTE1               --流程属性1
			,OBJATTRIBUTE2               --流程属性2
			,OBJATTRIBUTE3               --流程属性3
			,OBJATTRIBUTE4               --流程属性4
			,OBJATTRIBUTE5               --流程属性5
			,ORGID                       --登记机构号
			,ORGNAME                     --评估单位
			,USERID                      --登记人编号
			,USERNAME                    --登记人名称
			,INPUTDATE                   --登记日期
			,ARCHIVETIME                 --归档时刻
			,APPLYNO                     --申请编号
			,FLOWSTATE                   --流程状态
			,PROCESSINSTNO               --流程实例编号
			,PROCESSTASKNO               --流程任务编号
			,RELATIVETASKNO              --关联流程对象流水号
			,SERIALNO                    --流程对象流水号
			,TASKTYPE                    --任务类型
			,VERSION                     --版本
			,BASEFLOWNO                  --流程号
			,ARCHIVE                     --归档标识
			,MIGTFLAG                    --迁移标志：CRSRCRILCUPL
			,START_DT                    --开始日期
			,END_DT                      --结束日期
			,ID_MARK                     --删除标识
    )
    SELECT
	  	OBJECTTYPE                   --流程对象任务类型
			,OBJECTNO                    --流程对象编号
			,PHASETYPE                   --当前阶段类型
			,APPLYTYPE                   --申请类型
			,FLOWNO                      --流程模型编号
			,FLOWNAME                    --流程模型名称
			,PHASENO                     --当前阶段编号
			,PHASENAME                   --当前阶段名称
			,OBJDESCRIBE                 --流程描述
			,OBJATTRIBUTE1               --流程属性1
			,OBJATTRIBUTE2               --流程属性2
			,OBJATTRIBUTE3               --流程属性3
			,OBJATTRIBUTE4               --流程属性4
			,OBJATTRIBUTE5               --流程属性5
			,ORGID                       --登记机构号
			,ORGNAME                     --评估单位
			,USERID                      --登记人编号
			,USERNAME                    --登记人名称
			,INPUTDATE                   --登记日期
			,ARCHIVETIME                 --归档时刻
			,APPLYNO                     --申请编号
			,FLOWSTATE                   --流程状态
			,PROCESSINSTNO               --流程实例编号
			,PROCESSTASKNO               --流程任务编号
			,RELATIVETASKNO              --关联流程对象流水号
			,SERIALNO                    --流程对象流水号
			,TASKTYPE                    --任务类型
			,VERSION                     --版本
			,BASEFLOWNO                  --流程号
			,ARCHIVE                     --归档标识
			,MIGTFLAG                    --迁移标志：CRSRCRILCUPL
			,START_DT                    --开始日期
			,END_DT                      --结束日期
			,ID_MARK                     --删除标识
    FROM IOL.V_ICMS_FLOW_OBJECT  --视图-流程对象表
   WHERE ID_MARK <> 'D';

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

  END ETL_O_IOL_ICMS_FLOW_OBJECT;
/

