CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_LOAN_APP(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_LOAN_APP
  *  功能描述：贷款申请信息整合表
  *  口径描述：由于其他模块不使用该表报送，按照1104 S6301口径调整该表逻辑
         对公：取综合额度申请，和专项额度中能对应可售产品为各项贷款的申请。
               由于申请不通过/撤销的流水在信贷系统会直接删除，该表需要累数，累数功能在S层实现
         零售：家伟提数口径不清晰，暂时全部接入后去重。
               由于申请不通过/撤销的流水在信贷系统会直接删除，该表需要累数，累数功能在S层实现 -- 暂时全部计入
     联合网贷：目前只有网商贷，取网商贷当年申请授信客户（不论申请结果是否通过）及当年发放贷款客户。
  *  创建日期：20220507
  *  开发人员：蔡正伟
  *  来源表：  M_LOAN_APP_INFO
  *            M_CUST_CORP_INFO
  *            M_CUST_IND_INFO
  *  目标表：  S_LOAN_APP
  *  配置表：
  *  修改情况：
     序号  修改日期  修改人   修改原因
  *   1    20230222   liuyu    按照S6301口径调整逻辑，添加累数逻辑
  *   2    20230330   liuyu    零售申请直接取源表--张家伟
                               对公申请需要按月取数 --严希婧
      3    20230604   liuyu    添加个人经营贷款申请过滤条件 S_LOAN_APP 零售条线只要个人经营贷款的申请
                               调整LOAN_BIZ_TYP 贷款业务类型字段零售和联合网贷逻辑取标准产品映射结果
                                                 对公业务直接取申请业务品种，无法通过标准产品映射
      4    20240224   lwb      调整联合网贷中微粒贷产品部分的出数逻辑
      5    20240313   HYF      调整对公贷款部分逻辑，不继承上月数据，并剔除同业额度，企业类型为空默认中型
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_LOAN_APP'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'S_LOAN_APP'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

   -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理


  -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '贷款申请信息整合表-联合网贷';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_LOAN_APP
      (DATA_DT,                --数据日期
       LGL_REP_ID,             --法人编号
       APP_ID,                 --申请编号
       ORG_ID,                 --机构编号
       CUST_ID,                --客户编号
       APP_DT,                 --申请日期
       CUR,                    --币种
       APP_AMT,                --申请金额
       APRV_AMT,               --批准金额
       LOAN_BIZ_TYP,           --贷款业务类型
       APP_STAT,               --申请状态
       CORP_CUST_TYP,          --对公客户类型
       ENT_SCALE,              --企业规模
       OPR_CUST_TYP,           --经营性客户类型
       DEPT_LINE,              --部门条线
       DATA_SRC,                --数据来源
       LOAN_HAPP_TYPE_CD,        --发生类型
       CRDL_NO                  --申请客户证件号码
       ,STD_PROD_ID
       )

      SELECT A.DATA_DT                     AS DATA_DT,                      --数据日期
             A.LGL_REP_ID                  AS LGL_REP_ID,                   --法人编号
             A.APP_ID                      AS APP_ID,                       --申请编号
             A.ORG_ID                      AS ORG_ID,                       --机构编号
             A.CRDL_NO                     AS CUST_ID,                      --客户编号
             -- 联合网贷申请客户存在空值，按照身份证号统计
             A.APP_DT                      AS APP_DT,                       --申请日期
             A.CUR                         AS CUR,                          --币种
             A.APP_AMT                     AS APP_AMT,                      --申请金额
             A.APRV_AMT                    AS APRV_AMT,                     --批准金额
             NVL(TTA.TAR_VALUE_CODE,A.LOAN_BIZ_TYP)
                                           AS LOAN_BIZ_TYP,                 --贷款业务类型
             A.APP_STAT                    AS APP_STAT,                     --申请状态
             ''                            AS CORP_CUST_TYP,                --对公客户类型
             ''                            AS ENT_SCALE,                    --企业规模
             C.OPR_CUST_TYP                AS OPR_CUST_TYP,                 --经营性客户类型
             A.DEPT_LINE                   AS DEPT_LINE,                    --部门条线
             A.DATA_SRC                    AS DATA_SRC,                     --数据来源
             ''                            AS LOAN_HAPP_TYPE_CD,            --发生类型
             A.CRDL_NO                     AS CRDL_NO                       --申请客户证件号码
             ,A.LOAN_BIZ_TYP
        FROM RRP_MDL.M_LOAN_APP_INFO A --贷款申请信息
        LEFT JOIN RRP_MDL.M_CUST_IND_INFO C --个人客户信息
          ON A.CUST_ID = C.CUST_ID
         AND C.DATA_DT = V_P_DATE
        LEFT JOIN RRP_MDL.CODE_MAP                         TTA   --码值映射表(贷款类型)
          ON TTA.SRC_VALUE_CODE = A.LOAN_BIZ_TYP -- MOD BY LIUYU M层业务类型存的是标准产品号
         AND TTA.SRC_CLASS_CODE = 'STD0002'
         AND TTA.TAR_CLASS_CODE = 'T0001'
         AND TTA.MOD_FLG = 'MDM'
       WHERE A.DATA_DT = V_P_DATE
         AND A.DATA_SRC = '联合网贷'
         AND SUBSTR(A.APP_DT, 1, 6) >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') -1,'YYYYMMDD')  --去年年末
         AND SUBSTR(A.APP_DT, 1, 6) <= TO_CHAR(TO_DATE(V_P_DATE, 'YYYY/MM/DD'),'YYYYMMDD')  --小于等于报告日
         AND (TTA.TAR_VALUE_CODE LIKE '0102%'
             OR SUBSTR(A.LOAN_BIZ_TYP,0,5) IN ('20202','20102') ) -- 取个人经营贷的申请
         AND  a.loan_biz_typ not in ('202010100006','202010100008','202020100003')--剔除微粒贷部分
         ;
   -- 联合网贷不用累数，直接取最新的申请

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   COMMIT;


    -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '贷款申请信息整合表-微粒贷';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_LOAN_APP
      (DATA_DT,                --数据日期
       LGL_REP_ID,             --法人编号
       APP_ID,                 --申请编号
       ORG_ID,                 --机构编号
       CUST_ID,                --客户编号
       APP_DT,                 --申请日期
       CUR,                    --币种
       APP_AMT,                --申请金额
       APRV_AMT,               --批准金额
       LOAN_BIZ_TYP,           --贷款业务类型
       APP_STAT,               --申请状态
       CORP_CUST_TYP,          --对公客户类型
       ENT_SCALE,              --企业规模
       OPR_CUST_TYP,           --经营性客户类型
       DEPT_LINE,              --部门条线
       DATA_SRC,                --数据来源
       LOAN_HAPP_TYPE_CD,        --发生类型
       CRDL_NO                  --申请客户证件号码
       ,STD_PROD_ID
       )

     WITH TMP AS (SELECT C.CRDL_NO,MAX(OPR_CUST_TYP) as OPR_CUST_TYP FROM RRP_MDL.M_CUST_IND_INFO C --个人客户信息
          where  C.DATA_DT = V_P_DATE
            group by C.CRDL_NO
          )
SELECT       V_P_DATE                    AS DATA_DT,                      --数据日期
             ''                  AS LGL_REP_ID,                   --法人编号
             A.SEQNO                      AS APP_ID,                       --申请编号
             A.OPERATEORGID                      AS ORG_ID,                       --机构编号
             A.IDNO                     AS CUST_ID,                      --客户编号
             -- 联合网贷申请客户存在空值，按照身份证号统计
             TO_CHAR(to_date(REPLACE(SUBSTR(INPUTDATE,0,10),'/',''),'yyyymmdd'),'YYYYMMDD')     AS APP_DT,                       --申请日期
             'CNY'                         AS CUR,                          --币种
             ''                     AS APP_AMT,                      --申请金额
             ''                    AS APRV_AMT,                     --批准金额
             ''
                                           AS LOAN_BIZ_TYP,                 --贷款业务类型
             A.APPROVESTATUS                    AS APP_STAT,                     --申请状态
             ''                            AS CORP_CUST_TYP,                --对公客户类型
             ''                            AS ENT_SCALE,                    --企业规模
             C.OPR_CUST_TYP                AS OPR_CUST_TYP,                 --经营性客户类型
             '微粒贷'                   AS DEPT_LINE,                    --部门条线
             '联合网贷'                   AS DATA_SRC,                     --数据来源
             ''                            AS LOAN_HAPP_TYPE_CD,            --发生类型
             A.IDNO                     AS CRDL_NO,                       --申请客户证件号码
             '202020100003'       --默认为微粒贷经营
        FROM RRP_MDL.O_IOL_ICMS_WLD_IQP_LOAN_APP A --贷款申请信息
        LEFT JOIN TMP C --个人客户信息
          ON A.IDNO = C.CRDL_NO
       WHERE A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
         AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
         AND A.LIMITPURPOSE='BUSI'
         AND to_date(REPLACE(SUBSTR(INPUTDATE,0,10),'/',''),'yyyymmdd') >=TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') -1 --去年年末
         AND to_date(REPLACE(SUBSTR(INPUTDATE,0,10),'/',''),'yyyymmdd') <= TO_DATE(V_P_DATE, 'YYYYMMDD')  --小于等于报告日
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   COMMIT;

   V_STEP := 4;
   V_STEP_DESC := '贷款申请信息整合表-对公信贷取上月数据';
   V_STARTTIME := SYSDATE;
  /*--======================
   信贷系统的贷款申请不会保存一些可能的失败/撤销/拒绝的申请流水，需要按月累数BUSINESS_APPLY
  --======================*/
 /* INSERT INTO S_LOAN_APP
      (DATA_DT,                --数据日期
       LGL_REP_ID,             --法人编号
       APP_ID,                 --申请编号
       ORG_ID,                 --机构编号
       CUST_ID,                --客户编号
       APP_DT,                 --申请日期
       CUR,                    --币种
       APP_AMT,                --申请金额
       APRV_AMT,               --批准金额
       LOAN_BIZ_TYP,           --贷款业务类型
       APP_STAT,               --申请状态
       CORP_CUST_TYP,          --对公客户类型
       ENT_SCALE,              --企业规模
       OPR_CUST_TYP,           --经营性客户类型
       DEPT_LINE,              --部门条线
       DATA_SRC,               --数据来源
       LOAN_HAPP_TYPE_CD,      --发生类型
       CRDL_NO                 --申请客户证件号码
       ,STD_PROD_ID
       )

      SELECT V_P_DATE                      AS DATA_DT,                      --数据日期
             A.LGL_REP_ID                  AS LGL_REP_ID,                   --法人编号
             A.APP_ID                      AS APP_ID,                       --申请编号
             A.ORG_ID                      AS ORG_ID,                       --机构编号
             A.CUST_ID                     AS CUST_ID,                      --客户编号
             A.APP_DT                      AS APP_DT,                       --申请日期
             A.CUR                         AS CUR,                          --币种
             A.APP_AMT                     AS APP_AMT,                      --申请金额
             A.APRV_AMT                    AS APRV_AMT,                     --批准金额
             A.LOAN_BIZ_TYP                AS LOAN_BIZ_TYP,                 --贷款业务类型
             A.APP_STAT                    AS APP_STAT,                     --申请状态
             A.CORP_CUST_TYP               AS CORP_CUST_TYP,                --对公客户类型
             A.ENT_SCALE                   AS ENT_SCALE,                    --企业规模
             A.OPR_CUST_TYP                AS OPR_CUST_TYP,                 --经营性客户类型
             A.DEPT_LINE                   AS DEPT_LINE,                    --部门条线
             A.DATA_SRC                    AS DATA_SRC,                     --数据来源
             A.LOAN_HAPP_TYPE_CD           AS LOAN_HAPP_TYPE_CD,            --发生类型
             A.CRDL_NO                     AS CRDL_NO                       --申请客户证件号码
             ,A.LOAN_BIZ_TYP
        FROM RRP_MDL.S_LOAN_APP A --贷款申请信息
       WHERE A.DATA_DT = TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(V_P_DATE,'YYYYMMDD'),-1)),'YYYYMMDD')  -- 取上个月
         AND A.DATA_DT <> TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') -1,'YYYYMMDD') --不取上年末数据
         AND A.DATA_SRC IN ('对公信贷')
         ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   COMMIT;*/

   V_STEP := 5;
   V_STEP_DESC := '贷款申请信息整合表-对公取当年数据';
   V_STARTTIME := SYSDATE;

  INSERT INTO S_LOAN_APP
      (DATA_DT,                --数据日期
       LGL_REP_ID,             --法人编号
       APP_ID,                 --申请编号
       ORG_ID,                 --机构编号
       CUST_ID,                --客户编号
       APP_DT,                 --申请日期
       CUR,                    --币种
       APP_AMT,                --申请金额
       APRV_AMT,               --批准金额
       LOAN_BIZ_TYP,           --贷款业务类型
       APP_STAT,               --申请状态
       CORP_CUST_TYP,          --对公客户类型
       ENT_SCALE,              --企业规模
       OPR_CUST_TYP,           --经营性客户类型
       DEPT_LINE,              --部门条线
       DATA_SRC,                --数据来源
       LOAN_HAPP_TYPE_CD,        --发生类型
       LMT_UNDER_SELLBL_PROD_ID   --可售产品号
       ,STD_PROD_ID
       )

      SELECT A.DATA_DT                     AS DATA_DT,                      --数据日期
             A.LGL_REP_ID                  AS LGL_REP_ID,                   --法人编号
             A.APP_ID                      AS APP_ID,                       --申请编号
             A.ORG_ID                      AS ORG_ID,                       --机构编号
             A.CUST_ID                     AS CUST_ID,                      --客户编号
             A.APP_DT                      AS APP_DT,                       --申请日期
             A.CUR                         AS CUR,                          --币种
             A.APP_AMT                     AS APP_AMT,                      --申请金额
             A.APRV_AMT                    AS APRV_AMT,                     --批准金额
             A.LOAN_BIZ_TYP                AS LOAN_BIZ_TYP,                 --贷款业务类型
             A.APP_STAT                    AS APP_STAT,                     --申请状态
             B.CUST_CL                     AS CORP_CUST_TYP,                --对公客户类型
             NVL(B.ENT_SCALE,'M')          AS ENT_SCALE,                    --企业规模
             ''                            AS OPR_CUST_TYP,                 --经营性客户类型
             A.DEPT_LINE                   AS DEPT_LINE,                    --部门条线
             A.DATA_SRC                    AS DATA_SRC,                     --数据来源
             A.LOAN_HAPP_TYPE_CD           AS LOAN_HAPP_TYPE_CD,            --发生类型
             A.LMT_UNDER_SELLBL_PROD_ID    AS LMT_UNDER_SELLBL_PROD_ID      --可售产品
             ,A.LOAN_BIZ_TYP
        FROM RRP_MDL.M_LOAN_APP_INFO A --贷款申请信息
        LEFT JOIN RRP_MDL.M_CUST_CORP_INFO B --对公客户信息表
          ON A.CUST_ID = B.CUST_ID
         AND B.DATA_DT = V_P_DATE
       WHERE A.DATA_DT = V_P_DATE
         AND A.DATA_SRC IN ('对公信贷')
         AND SUBSTR(A.APP_DT,1,4) = SUBSTR(V_P_DATE,1,4) -- 取当年申请数据
         /*AND SUBSTR(A.APP_DT,1,4) = SUBSTR(V_P_DATE,1,4)*/
         AND (A.STD_PROD_ID IN ('100010100001') -- 公司客户综合授信额度
             OR (A.STD_PROD_ID IN ('100010100002') -- 公司客户专项授信额度
                 AND SUBSTR(A.LMT_UNDER_SELLBL_PROD_ID,1,1) = '2' -- 可售产品为贷款的
                )
             )
         ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   COMMIT;

   V_STEP := 6;
   V_STEP_DESC := '贷款申请信息整合表-零售取当年数据';
   V_STARTTIME := SYSDATE;

  INSERT INTO S_LOAN_APP
      (DATA_DT,                --数据日期
       LGL_REP_ID,             --法人编号
       APP_ID,                 --申请编号
       ORG_ID,                 --机构编号
       CUST_ID,                --客户编号
       APP_DT,                 --申请日期
       CUR,                    --币种
       APP_AMT,                --申请金额
       APRV_AMT,               --批准金额
       LOAN_BIZ_TYP,           --贷款业务类型
       APP_STAT,               --申请状态
       CORP_CUST_TYP,          --对公客户类型
       ENT_SCALE,              --企业规模
       OPR_CUST_TYP,           --经营性客户类型
       DEPT_LINE,              --部门条线
       DATA_SRC,               --数据来源
       LOAN_HAPP_TYPE_CD,      --发生类型
       CRDL_NO                 --申请客户证件号码
       ,STD_PROD_ID
       )

      SELECT A.DATA_DT                     AS DATA_DT,                      --数据日期
             A.LGL_REP_ID                  AS LGL_REP_ID,                   --法人编号
             A.APP_ID                      AS APP_ID,                       --申请编号
             A.ORG_ID                      AS ORG_ID,                       --机构编号
             A.CUST_ID                     AS CUST_ID,                      --客户编号
             A.APP_DT                      AS APP_DT,                       --申请日期
             A.CUR                         AS CUR,                          --币种
             A.APP_AMT                     AS APP_AMT,                      --申请金额
             A.APRV_AMT                    AS APRV_AMT,                     --批准金额
             NVL(TTA.TAR_VALUE_CODE,A.LOAN_BIZ_TYP)
                                           AS LOAN_BIZ_TYP,                 --贷款业务类型
             A.APP_STAT                    AS APP_STAT,                     --申请状态
             ''                            AS CORP_CUST_TYP,                --对公客户类型
             ''                            AS ENT_SCALE,                    --企业规模
             C.OPR_CUST_TYP                AS OPR_CUST_TYP,                 --经营性客户类型
             A.DEPT_LINE                   AS DEPT_LINE,                    --部门条线
             A.DATA_SRC                    AS DATA_SRC,                     --数据来源
             A.LOAN_HAPP_TYPE_CD           AS LOAN_HAPP_TYPE_CD,            --发生类型
             C.CRDL_NO                     AS CRDL_NO                       --申请客户证件号码
             ,A.LOAN_BIZ_TYP
        FROM RRP_MDL.M_LOAN_APP_INFO A --贷款申请信息
        LEFT JOIN RRP_MDL.CODE_MAP                         TTA   --码值映射表(贷款类型)
          ON TTA.SRC_VALUE_CODE = A.LOAN_BIZ_TYP -- MOD BY LIUYU M层业务类型存的是标准产品号
         AND TTA.SRC_CLASS_CODE = 'STD0002'
         AND TTA.TAR_CLASS_CODE = 'T0001'
         AND TTA.MOD_FLG = 'MDM'
        LEFT JOIN RRP_MDL.M_CUST_IND_INFO C --个人客户信息
          ON A.CUST_ID = C.CUST_ID
         AND C.DATA_DT = V_P_DATE
       WHERE A.DATA_DT = V_P_DATE
         AND A.DATA_SRC IN ('零售贷款')
         AND SUBSTR(A.APP_DT,1,4) = SUBSTR(V_P_DATE,1,4) -- 取当年申请数据 --张家伟要求
         AND (TTA.TAR_VALUE_CODE LIKE '0102%'
             OR SUBSTR(A.LOAN_BIZ_TYP,0,5) IN ('20202','20102') ) -- 取个人经营贷的申请
         ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   COMMIT;

   -- 表分析
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

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
   V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_S_LOAN_APP;
/

