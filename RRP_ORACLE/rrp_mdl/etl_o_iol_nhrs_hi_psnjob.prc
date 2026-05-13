CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_NHRS_HI_PSNJOB(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_NHRS_HI_PSNJOB
  *  功能描述：工作信息
  *  创建日期：20251105
  *  开发人员：于敬艺
  *  来源表： IOL.V_NHRS_HI_PSNJOB
  *  目标表： O_IOL_NHRS_HI_PSNJOB
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251105  YJY     首次创建
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_NHRS_HI_PSNJOB'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_NHRS_HI_PSNJOB';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-工作信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_NHRS_HI_PSNJOB NOLOGGING
    (   ASSGID           --人员任职ID
       ,BEGINDATE        --开始日期
       ,CLERKCODE        --员工号
       ,CREATIONTIME     --创建时间
       ,CREATOR          --创建人
       ,DATAORIGINFLAG   --分布式
       ,DEPOSEMODE       --免职方式
       ,DR               --备用DR
       ,ENDDATE          --结束日期
       ,ENDFLAG          --是否结束
       ,ISMAINJOB        --是否主职
       ,JOBMODE          --任职方式
       ,LASTFLAG         --最新记录
       ,MEMO             --备注
       ,MODIFIEDTIME     --修改时间
       ,MODIFIER         --修改人
       ,OCCUPATION       --职业
       ,ORIBILLPK        --来源单据主键
       ,ORIBILLTYPE      --来源单据类型
       ,PK_DEPT          --部门
       ,PK_DEPT_V        --部门版本信息
       ,PK_GROUP         --集团
       ,PK_HRGROUP       --所属集团
       ,PK_HRORG         --人力资源组织
       ,PK_JOB           --职务
       ,PK_JOB_TYPE      --任职类型
       ,PK_JOBGRADE      --职级
       ,PK_JOBRANK       --职等
       ,PK_ORG           --组织
       ,PK_ORG_V         --组织版本信息
       ,PK_POST          --岗位
       ,PK_POSTSERIES    --岗位序列
       ,PK_PSNCL         --人员类别
       ,PK_PSNDOC        --人员
       ,PK_PSNJOB        --工作记录
       ,PK_PSNORG        --组织关系主键
       ,POSTSTAT         --是否在岗
       ,PSNTYPE          --人员类型
       ,RECORDNUM        --记录序号
       ,SERIES           --职务类别
       ,SHOWORDER        --人员顺序号
       ,TRIAL_FLAG       --是否试用
       ,TRIAL_TYPE       --试用类型
       ,TRNSEVENT        --异动事件
       ,TRNSREASON       --异动原因
       ,TRNSTYPE         --异动类型
       ,TS               --时间戳
       ,WORKTYPE         --工种
       ,JOBGLBDEF1       --办公地点及楼层
       ,JOBGLBDEF2       --员工层级
       ,JOBGLBDEF3       --是否本部办公
       ,JOBGLBDEF4       --是否为市场人员
       ,JOBGLBDEF5       --是否为管理人员
       ,JOBGLBDEF6       --是否清交完成
       ,JOBGLBDEF9       --费用核算部门
       ,JOBGLBDEF7       --兼职费用核算部门
       ,JOBGLBDEF8       --兼职费用核算部门
       ,JOBGLBDEF10      --职务大类
       ,JOBGLBDEF11      --清缴完成日期
       ,START_DT         --开始时间
       ,END_DT           --结束时间
       ,ID_MARK          --增删标志
       ,ETL_TIMESTAMP    --ETL处理时间戳
     )
  SELECT /*+PARALLEL*/
        ASSGID           --人员任职ID
       ,BEGINDATE        --开始日期
       ,CLERKCODE        --员工号
       ,CREATIONTIME     --创建时间
       ,CREATOR          --创建人
       ,DATAORIGINFLAG   --分布式
       ,DEPOSEMODE       --免职方式
       ,DR               --备用DR
       ,ENDDATE          --结束日期
       ,ENDFLAG          --是否结束
       ,ISMAINJOB        --是否主职
       ,JOBMODE          --任职方式
       ,LASTFLAG         --最新记录
       ,MEMO             --备注
       ,MODIFIEDTIME     --修改时间
       ,MODIFIER         --修改人
       ,OCCUPATION       --职业
       ,ORIBILLPK        --来源单据主键
       ,ORIBILLTYPE      --来源单据类型
       ,PK_DEPT          --部门
       ,PK_DEPT_V        --部门版本信息
       ,PK_GROUP         --集团
       ,PK_HRGROUP       --所属集团
       ,PK_HRORG         --人力资源组织
       ,PK_JOB           --职务
       ,PK_JOB_TYPE      --任职类型
       ,PK_JOBGRADE      --职级
       ,PK_JOBRANK       --职等
       ,PK_ORG           --组织
       ,PK_ORG_V         --组织版本信息
       ,PK_POST          --岗位
       ,PK_POSTSERIES    --岗位序列
       ,PK_PSNCL         --人员类别
       ,PK_PSNDOC        --人员
       ,PK_PSNJOB        --工作记录
       ,PK_PSNORG        --组织关系主键
       ,POSTSTAT         --是否在岗
       ,PSNTYPE          --人员类型
       ,RECORDNUM        --记录序号
       ,SERIES           --职务类别
       ,SHOWORDER        --人员顺序号
       ,TRIAL_FLAG       --是否试用
       ,TRIAL_TYPE       --试用类型
       ,TRNSEVENT        --异动事件
       ,TRNSREASON       --异动原因
       ,TRNSTYPE         --异动类型
       ,TS               --时间戳
       ,WORKTYPE         --工种
       ,JOBGLBDEF1       --办公地点及楼层
       ,JOBGLBDEF2       --员工层级
       ,JOBGLBDEF3       --是否本部办公
       ,JOBGLBDEF4       --是否为市场人员
       ,JOBGLBDEF5       --是否为管理人员
       ,JOBGLBDEF6       --是否清交完成
       ,JOBGLBDEF9       --费用核算部门
       ,JOBGLBDEF7       --兼职费用核算部门
       ,JOBGLBDEF8       --兼职费用核算部门
       ,JOBGLBDEF10      --职务大类
       ,JOBGLBDEF11      --清缴完成日期
       ,START_DT         --开始时间
       ,END_DT           --结束时间
       ,ID_MARK          --增删标志
       ,ETL_TIMESTAMP    --ETL处理时间戳
    FROM IOL.V_NHRS_HI_PSNJOB   --工作信息_视图
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D'
       ;

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

  END ETL_O_IOL_NHRS_HI_PSNJOB;
/

