CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_CTMS_TBS_VS_CPTYS(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_CTMS_TBS_VS_CPTYS
  *  功能描述：交易对手视图
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IOL_CTMS_TBS_VS_CPTYS
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20241225  YJY      优化脚本
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_CTMS_TBS_VS_CPTYS'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_CTMS_TBS_VS_CPTYS';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-交易对手视图';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_CTMS_TBS_VS_CPTYS NOLOGGING
    (  CPTYS_ID                         --交易对手ID
      ,ASPCLIENT_ID                     --部门ID
      ,CPTYS_SHORTNAME                  --交易对手简称
      ,CPTYS_NAME                       --交易对手全称
      ,CPTYS_NAME2                      --交易对手名称2
      ,NAME_SRC                         --电子证书名称
      ,KEY_SRC                          --数字证书号
      ,ISLINK_SRC                       --是否连接电子证书
      ,LASTMODIFIED                     --最后修改时间
      ,DATASYMBOLCONFIG_ID              --数据源配置ID
      ,LABEL                            --其他系统代号
      ,RATING_LEVEL                     --内部评级
      ,FIELD1                           --扩展字段1
      ,FIELD2                           --扩展字段2
      ,FIELD3                           --扩展字段3
      ,COUNTERPARTY_ENAME               --交易对手英文名称
      ,COUNTERPARTY_SHORT_ENAME         --交易对手英文简称
      ,CONTACT_NAME                     --联系人姓名
      ,TELEPHONE                        --电话
      ,FAX                              --传真
      ,IS_ISSUER                        --是否是发行人
      ,IS_BANK                          --是否是金融机构
      ,IS_GUARANTEE                     --是否是担保人
      ,IS_CUSTODY                       --是否是托管机构
      ,CUSTOMER_TYPE_CODE               --行业类别CODE
      ,CUSTOMER_TYPE_NAME               --行业类别NAME
      ,PARENT                           --母公司ID
      ,EX_CODE                          --电子联行号
      ,EX_ACCOUNT                       --大额支付系统号
      ,SWIFT_CODE                       --SWIFT电文代号
      ,REF_ISSUER_ID                    --发行人/担保人ID
      ,ISSUER_NAME                      --发行人/担保人中文名
      ,CFETS_MEMBER_ATTR                --是否外汇会员
      ,MASTER_SHORT_CNAME               --主机构中文短名
      ,MASTER_CFETS_ID                  --主机构本币会员ID
      ,MASTER_CNTY_SEQ                  --主机构系统交易对手编号
      ,START_DT                         --开始时间
      ,END_DT                           --结束时间
      ,ID_MARK                           --增删标志
     )
  SELECT /*+PARALLEL*/
       CPTYS_ID                         --交易对手ID
      ,ASPCLIENT_ID                     --部门ID
      ,CPTYS_SHORTNAME                  --交易对手简称
      ,CPTYS_NAME                       --交易对手全称
      ,CPTYS_NAME2                      --交易对手名称2
      ,NAME_SRC                         --电子证书名称
      ,KEY_SRC                          --数字证书号
      ,ISLINK_SRC                       --是否连接电子证书
      ,LASTMODIFIED                     --最后修改时间
      ,DATASYMBOLCONFIG_ID              --数据源配置ID
      ,LABEL                            --其他系统代号
      ,RATING_LEVEL                     --内部评级
      ,FIELD1                           --扩展字段1
      ,FIELD2                           --扩展字段2
      ,FIELD3                           --扩展字段3
      ,COUNTERPARTY_ENAME               --交易对手英文名称
      ,COUNTERPARTY_SHORT_ENAME         --交易对手英文简称
      ,CONTACT_NAME                     --联系人姓名
      ,TELEPHONE                        --电话
      ,FAX                              --传真
      ,IS_ISSUER                        --是否是发行人
      ,IS_BANK                          --是否是金融机构
      ,IS_GUARANTEE                     --是否是担保人
      ,IS_CUSTODY                       --是否是托管机构
      ,CUSTOMER_TYPE_CODE               --行业类别CODE
      ,CUSTOMER_TYPE_NAME               --行业类别NAME
      ,PARENT                           --母公司ID
      ,EX_CODE                          --电子联行号
      ,EX_ACCOUNT                       --大额支付系统号
      ,SWIFT_CODE                       --SWIFT电文代号
      ,REF_ISSUER_ID                    --发行人/担保人ID
      ,ISSUER_NAME                      --发行人/担保人中文名
      ,CFETS_MEMBER_ATTR                --是否外汇会员
      ,MASTER_SHORT_CNAME               --主机构中文短名
      ,MASTER_CFETS_ID                  --主机构本币会员ID
      ,MASTER_CNTY_SEQ                  --主机构系统交易对手编号
      ,START_DT                         --开始时间
      ,END_DT                           --结束时间
      ,ID_MARK                           --增删标志
    FROM IOL.V_CTMS_TBS_VS_CPTYS   --交易对手视图_视图
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

  END ETL_O_IOL_CTMS_TBS_VS_CPTYS;
/

