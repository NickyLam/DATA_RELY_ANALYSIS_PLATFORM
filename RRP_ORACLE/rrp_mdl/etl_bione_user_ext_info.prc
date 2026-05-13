CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_bione_user_ext_info(I_DATADATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_bione_user_ext_info
  *  功能描述：行员信息表
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_CLERK_INFO
  *  目标表： bione_user_ext_info
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
                2    20220615           修改参数
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(100) := 'ETL_bione_user_ext_info'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_DATADATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM bione_user_ext_info T WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE bione_user_ext_info';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-行员信息表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.bione_user_ext_info
  (      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,CLERK_ID  --行员编号
      ,CLERK_NAME  --行员名称
      ,TELLER_FLG  --柜员标志
      ,TELLER_ID  --柜员编号
      ,REGION_ACCT_NUM  --域账号
      ,EMPLY_TYPE_CD  --员工类型代码
      ,CERT_TYPE_CD  --证件类型代码
      ,CERT_NO  --证件号码
      ,GENDER_CD  --性别代码
      ,BIRTH_DT  --出生日期
      ,NATIONTY_CD  --民族代码
      ,POLITIC_STATUS_CD  --政治面貌代码
      ,MARRIAGE_SITU_CD  --婚姻状况代码
      ,EDU_CD  --学历代码
      ,POST_CD  --职务代码
      ,TITLE_CD  --职称代码
      ,FIR_WORK_DT  --首次工作日期
      ,EMPYT_DT  --入职日期
      ,LOCAL_DEPT_ID  --所在部门编号
      ,DIMISSION_DT  --离职日期
      ,EMPLY_STATUS_CD  --员工状态代码
      ,EMPLY_SYS_STATUS_CD  --员工系统状态代码
      ,BELONG_ORG_ID  --所属机构编号
      ,WORK_TEL_INTER_AREA_CD  --单位电话国际区号
      ,WORK_TEL_AREA_CD  --单位电话区号
      ,WORK_TEL_NUM  --单位电话号码
      ,FAX_AREA_CD  --传真区号
      ,FAX_NUM  --传真号码
      ,MOBILE_PHONE_NUM  --移动电话号码
      ,CTY_CD  --国家代码
      ,DTL_ADDR  --详细地址
      ,E_MAIL_ADDR  --电子邮箱地址
      ,DING_TALK_USER_ID  --钉钉用户编号
      ,JOBS_CD  --岗位代码
      ,JOBS_CATE  --岗位类别
      ,JOBS_NAME  --岗位名称
      ,CUST_MGR_FLG  --客户经理标志
      ,CUST_MGR_LEV  --客户经理级别
      ,TELLER_LEV_CD  --柜员级别代码
      ,TELLER_DIRECTOR_ID  --柜员主管编号
      ,VTUAL_ACCTI_ORG_ID  --虚拟核算机构编号
      ,WORK_TEL_EXT_NUM  --单位电话分机号
      ,FAX_INTER_AREA_CD  --传真国际区号
      ,FAX_EXT_NUM  --传真分机号
      ,RESD_TEL_INTER_AREA_CD  --住宅电话国际区号
      ,RESD_TEL_DOM_AREA_CD  --住宅电话国内区号
      ,RESD_TEL  --住宅电话
      ,RESD_TEL_EXT_NUM  --住宅电话分机号
      ,MOBILE_PHONE_NUM_1  --移动电话号码1
      ,MOBILE_PHONE_NUM_2  --移动电话号码2
      ,MOBILE_PHONE_NUM_3  --移动电话号码3
      ,ZIP_CD  --邮政编码
      ,LOCAL_PROV  --所在省份
      ,SITE  --所在地区
      ,POSTN_CD  --职位代码
      ,POST_CATE_ID  --职务类别编号
      ,POST_NAME  --职务名称
    ,JOB_CD --任务代码
    )
    SELECT

      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,CLERK_ID  --行员编号
      ,CLERK_NAME  --行员名称
      ,TELLER_FLG  --柜员标志
      ,TELLER_ID  --柜员编号
      ,REGION_ACCT_NUM  --域账号
      ,EMPLY_TYPE_CD  --员工类型代码
      ,CERT_TYPE_CD  --证件类型代码
      ,CERT_NO  --证件号码
      ,GENDER_CD  --性别代码
      ,BIRTH_DT  --出生日期
      ,NATIONTY_CD  --民族代码
      ,POLITIC_STATUS_CD  --政治面貌代码
      ,MARRIAGE_SITU_CD  --婚姻状况代码
      ,EDU_CD  --学历代码
      ,POST_CD  --职务代码
      ,TITLE_CD  --职称代码
      ,FIR_WORK_DT  --首次工作日期
      ,EMPYT_DT  --入职日期
      ,LOCAL_DEPT_ID  --所在部门编号
      ,DIMISSION_DT  --离职日期
      ,EMPLY_STATUS_CD  --员工状态代码
      ,EMPLY_SYS_STATUS_CD  --员工系统状态代码
      ,BELONG_ORG_ID  --所属机构编号
      ,WORK_TEL_INTER_AREA_CD  --单位电话国际区号
      ,WORK_TEL_AREA_CD  --单位电话区号
      ,WORK_TEL_NUM  --单位电话号码
      ,FAX_AREA_CD  --传真区号
      ,FAX_NUM  --传真号码
      ,MOBILE_PHONE_NUM  --移动电话号码
      ,CTY_CD  --国家代码
      ,DTL_ADDR  --详细地址
      ,E_MAIL_ADDR  --电子邮箱地址
      ,DING_TALK_USER_ID  --钉钉用户编号
      ,JOBS_CD  --岗位代码
      ,JOBS_CATE  --岗位类别
      ,JOBS_NAME  --岗位名称
      ,CUST_MGR_FLG  --客户经理标志
      ,CUST_MGR_LEV  --客户经理级别
      ,TELLER_LEV_CD  --柜员级别代码
      ,TELLER_DIRECTOR_ID  --柜员主管编号
      ,VTUAL_ACCTI_ORG_ID  --虚拟核算机构编号
      ,WORK_TEL_EXT_NUM  --单位电话分机号
      ,FAX_INTER_AREA_CD  --传真国际区号
      ,FAX_EXT_NUM  --传真分机号
      ,RESD_TEL_INTER_AREA_CD  --住宅电话国际区号
      ,RESD_TEL_DOM_AREA_CD  --住宅电话国内区号
      ,RESD_TEL  --住宅电话
      ,RESD_TEL_EXT_NUM  --住宅电话分机号
      ,MOBILE_PHONE_NUM_1  --移动电话号码1
      ,MOBILE_PHONE_NUM_2  --移动电话号码2
      ,MOBILE_PHONE_NUM_3  --移动电话号码3
      ,ZIP_CD  --邮政编码
      ,LOCAL_PROV  --所在省份
      ,SITE  --所在地区
      ,POSTN_CD  --职位代码
      ,POST_CATE_ID  --职务类别编号
      ,POST_NAME  --职务名称
    ,JOB_CD --任务代码
    FROM ICL.V_CMM_CLERK_INFO  --视图-行员信息表
    WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
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
  V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_bione_user_ext_info;
/

