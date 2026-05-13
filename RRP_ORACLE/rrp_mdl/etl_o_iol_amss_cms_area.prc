CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_AMSS_CMS_AREA(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_AMSS_CMS_AREA
  *  功能描述：地区表
  *  创建日期：20251205
  *  开发人员：于敬艺
  *  来源表： IOL.V_AMSS_CMS_AREA
  *  目标表： O_IOL_AMSS_CMS_AREA
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251205  YJY     首次创建
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_AMSS_CMS_AREA'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_AMSS_CMS_AREA';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-地区表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_AMSS_CMS_AREA NOLOGGING
    (       AREA_CODE              --地区编号.
           ,AREA_NAME              --地区名称.
           ,AREA_TYPE              --地区类型.1国家，2省份，3城市，4县/区
           ,PARENT_AREA            --所属地区.
           ,ZIP_CODE               --邮政编号.
           ,TEL_CODE               --电话区号.生成渠道编号时要用到
           ,ENABLED                --是否启用.
           ,NAME_PY                --地区名称全拼.
           ,NAME_SPY               --地区名称拼音缩写.
           ,REMARK                 --备注.
           ,CREATE_USER            --创建用户.
           ,CREATE_EMP             --创建人.
           ,CREATE_TIME            --创建时间.
           ,UPDATE_TIME            --更新时间.
           ,ALI_V2_AREA_CODE       --支付宝V2地区编码
           ,BEST_PAY_AREA_CODE     --翼支付地区码
           ,HEBAO_AREA_CODE        --和包地区编码
           ,UNION_PAY_AREA_CODE    --银联地区编号
           ,SFT_AREA_CODE          --盛付通地区编码
           ,SFT_AREA_NAME          --盛付通地区名
           ,CFCA_AREA_CODE         --清算协会地区编码
           ,JL_AREA_CODE           --嘉联地区码
           ,YZ_AREA_CODE           --银总地区编码
           ,START_DT               --开始时间
           ,END_DT                 --结束时间
           ,ID_MARK                --增删标志
           ,ETL_TIMESTAMP          --ETL处理时间戳
     )
  SELECT /*+PARALLEL*/
            AREA_CODE              --地区编号.
           ,AREA_NAME              --地区名称.
           ,AREA_TYPE              --地区类型.1国家，2省份，3城市，4县/区
           ,PARENT_AREA            --所属地区.
           ,ZIP_CODE               --邮政编号.
           ,TEL_CODE               --电话区号.生成渠道编号时要用到
           ,ENABLED                --是否启用.
           ,NAME_PY                --地区名称全拼.
           ,NAME_SPY               --地区名称拼音缩写.
           ,REMARK                 --备注.
           ,CREATE_USER            --创建用户.
           ,CREATE_EMP             --创建人.
           ,CREATE_TIME            --创建时间.
           ,UPDATE_TIME            --更新时间.
           ,ALI_V2_AREA_CODE       --支付宝V2地区编码
           ,BEST_PAY_AREA_CODE     --翼支付地区码
           ,HEBAO_AREA_CODE        --和包地区编码
           ,UNION_PAY_AREA_CODE    --银联地区编号
           ,SFT_AREA_CODE          --盛付通地区编码
           ,SFT_AREA_NAME          --盛付通地区名
           ,CFCA_AREA_CODE         --清算协会地区编码
           ,JL_AREA_CODE           --嘉联地区码
           ,YZ_AREA_CODE           --银总地区编码
           ,START_DT               --开始时间
           ,END_DT                 --结束时间
           ,ID_MARK                --增删标志
           ,ETL_TIMESTAMP          --ETL处理时间戳
    FROM IOL.V_AMSS_CMS_AREA   --地区表
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

  END ETL_O_IOL_AMSS_CMS_AREA;
/

