CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ISBS_IMG(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_ISBS_IMG
  *  功能描述：发票信息表 信用证
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： IOL.V_ISBS_IMG
  *  目标表： O_IOL_ISBS_IMG
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
                2    20220615           修改参数
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_ISBS_IMG'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM O_IOL_ISBS_IMG T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE O_IOL_ISBS_IMG';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-发票信息表 信用证';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_ISBS_IMG
  (      INR  --数据序号
        ,MSGID  --报文标识号
        ,OBJTYP  --关联业务表类型
        ,OBJINR  --关联业务表INR
        ,FILEID  --人行回传影像ID
        ,FILNAM  --影像名称
        ,FILPTH  --文件存放路径
        ,INIFRM  --对应的业务交易
        ,FILEFRM  --影像类别
        ,FILETYPE  --影像类型
        ,FILEDESC  --影像描述
        ,VLDFLG  --有效标识
        ,FPID  --发票影像ID
        ,INVTP  --发票类型
        ,INVNB  --发票号码
        ,INVOICECODE  --发票代码
        ,UNTAXAMT  --未税金额
        ,INVDT  --开票日期
        ,YXFLG  --影像分类
        ,BRANCH  --所属机构
        ,OWNREF  --业务编号
        ,DELFLG  --删除标志
        ,UPDOW  --上传/下载
        ,ISDOW  --下载成功标志
        ,USRKEY  --柜员号
        ,CREDAT  --创建时间
        ,ETL_DT  --数据日期

    )
    SELECT

             INR  --数据序号
        ,MSGID  --报文标识号
        ,OBJTYP  --关联业务表类型
        ,OBJINR  --关联业务表INR
        ,FILEID  --人行回传影像ID
        ,FILNAM  --影像名称
        ,FILPTH  --文件存放路径
        ,INIFRM  --对应的业务交易
        ,FILEFRM  --影像类别
        ,FILETYPE  --影像类型
        ,FILEDESC  --影像描述
        ,VLDFLG  --有效标识
        ,FPID  --发票影像ID
        ,INVTP  --发票类型
        ,INVNB  --发票号码
        ,INVOICECODE  --发票代码
        ,UNTAXAMT  --未税金额
        ,INVDT  --开票日期
        ,YXFLG  --影像分类
        ,BRANCH  --所属机构
        ,OWNREF  --业务编号
        ,DELFLG  --删除标志
        ,UPDOW  --上传/下载
        ,ISDOW  --下载成功标志
        ,USRKEY  --柜员号
        ,CREDAT  --创建时间
        ,ETL_DT  --数据日期
    FROM IOL.V_ISBS_IMG  --视图-发票信息表 信用证
    WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


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

  END ETL_O_IOL_ISBS_IMG;
/

