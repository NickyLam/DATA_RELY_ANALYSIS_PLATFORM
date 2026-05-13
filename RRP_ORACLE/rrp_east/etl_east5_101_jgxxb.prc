CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_101_JGXXB(I_P_DATE IN INTEGER, --跑批日期
                                                O_ERRCODE OUT VARCHAR2 --错误代码
                                                )
/***********************************************************************
  **  存储过程详细说明：机构信息表
  **  存储过程名称:  ETL_EAST5_101_JGXXB
  **  存储过程创建日期:2022-03-07
  **  存储过程创建人:蔡正伟
  **  输入参数:   I_P_DATE
  **  输出参数:   O_ERRCODE
  **  返回值:     O_ERRCODE
  **  修改日期    修改人      修改原因
  **  20220527    蔡正伟      剔除负责人姓名空格
  **  20220628    LIP         修改日志记录格式，修改字段超长、字段换行问题
  **  20260106    LIP         对联系电话进行截取
  ************************************************************************/
IS
  V_P_DATE           VARCHAR2(8);         --数据日期
  V_MONTH_END_DATEID VARCHAR2(8);         --本月月底日期
  V_PARTITION_NAME   VARCHAR2(100);       --分区名称
  V_FREQ_FLAG        VARCHAR2(10);        --跑批频度
  V_STEP             INTEGER := 0;        --任务号
  V_STARTTIME        DATE;                --处理开始时间
  V_ENDTIME          DATE;                --处理结束时间
  V_SQLCOUNT         INTEGER := 0;        --更新或删除影响的记录数
  V_SQLMSG    	     VARCHAR2(300);       --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(100);       --处理步骤描述
  V_TABLE_NAME       VARCHAR2(100) := 'EAST5_101_JGXXB'; --表名称
  V_PROC_NAME        VARCHAR2(100) := 'ETL_EAST5_101_JGXXB'; --存储过程名称
BEGIN
  V_P_DATE  := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  --将参数转化为日期格式，判读输入参数是否符合日期要求
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_PARTITION_NAME   := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG        := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN
    V_STEP := 1;
    V_STEP_DESC := '删除当日分区数据';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE, V_TABLE_NAME, O_ERRCODE); --增加分区
    RRP_EAST.ETL_PARTITION_ADD(V_P_DATE, V_TABLE_NAME, 1, O_ERRCODE); --删除当日分区数据

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '跑批正确：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --程序业务逻辑处理主体部分
    V_STEP := 2;
    V_STEP_DESC := '插入机构信息表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_101_JGXXB(
      RID,        --数据主键
      YHJGDM,     --银行机构代码
      NBJGH,      --内部机构号
      JRXKZH,     --金融许可证号
      YYZZH,      --营业执照号
      YHJGMC,     --银行机构名称
      JGLB,       --机构类别
      XZQHDM,     --行政区划代码
      YYZT,       --营业状态
      CLRQ,       --成立日期
      JGLXDH,     --机构联系电话
      JGDZ,       --机构地址
      FZRXM,      --负责人姓名
      FZRZW,      --负责人职务
      FZRLXDH,    --负责人联系电话
      BBZ,        --备注
      CJRQ,       --采集日期
      DEPT_NO,    --部门编号
      SRC_SYS_ID, --来源系统ID
      ISSUED_NO,  --填报机构
      ORG_NO,     --报送机构
      ADDRESS,    --归属地
      GSFZJG      --归属分支机构
      )
    SELECT SYS_GUID()                                     AS RID,        --数据主键
           A.PBC_NO                                       AS YHJGDM,     --银行机构代码 12位人行支付行号或SWIFT行号。
           A.ORG_ID                                       AS NBJGH,      --内部机构号
           A.FIN_PERMIT_NO                                AS JRXKZH,     --金融许可证号
           NVL(TRIM(A.USCC),A.BSN_LCNS_REGD_NO)           AS YYZZH,      --营业执照号 已登记统一社会信用代码的，填18位统一社会信用代码；未登记统一社会信用代码的，填报营业执照注册号。
           A.ORG_NM                                       AS YHJGMC,     --银行机构名称
           CODE.TAR_VALUE_NAME                            AS JGLB,       --机构类别
           A.REGD_LAND_AREA_CD                            AS XZQHDM,     --行政区划代码
           CODE1.TAR_VALUE_NAME                           AS YYZT,       --营业状态
           NVL(A.ESTM_DT,'99991231')                      AS CLRQ,       --成立日期
           TRIM(A.ORG_TEL)                                AS JGLXDH,     --机构联系电话
           REPLACE(REPLACE(TRIM(A.ORG_ADDR),CHR(10),''),CHR(13),'') AS JGDZ, --机构地址 --MODIFY BY LIP 20220628
           TRIM(A.PIC_NM)                                 AS FZRXM,      --负责人姓名--MODIFY BY CAIZHENGWEI 20220527 剔除空格
           A.PIC_JOB                                      AS FZRZW,      --负责人职务
           --TRIM(A.PIC_TEL)                                AS FZRLXDH,    --负责人联系电话
           TRIM(SUBSTRB(A.PIC_TEL,1,70))                  AS FZRLXDH,    --负责人联系电话 --MOD BY LIP 20260106
           ''                                             AS BBZ,        --备注
           V_MONTH_END_DATEID                             AS CJRQ,       --采集日期：月末最后一天
           '000'                                          AS DEPT_NO,    --部门编号
           '01'                                           AS SRC_SYS_ID, --来源系统ID
           '000000'                                       AS ISSUED_NO,  --填报机构
           '000000'                                       AS ORG_NO,     --报送机构 总行
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                           AS ADDRESS,    --归属地
           '9999'                                         AS GSFZJG      --归属分支机构
      FROM RRP_MDL.M_PUM_ORG_INFO_EAST A --机构表
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = A.ORG_TYP
       AND CODE.SRC_CLASS_CODE = 'Z0020' --机构类别
       AND CODE.TAR_CLASS_CODE = 'Z0020' --机构类别
       AND CODE.MOD_FLG = 'EAST' --MODIFY BY CHENGW 20220906 更还码值为01 02 03 04
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.OPR_STAT
       AND CODE1.SRC_CLASS_CODE = 'Z0006'
       AND CODE1.TAR_CLASS_CODE = 'Z0006' --营业状态
       AND CODE1.MOD_FLG = 'EAST' --MODIFY BY CHENGW 20220906 更还码值为01 02
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.ORG_ID NOT LIKE '%902' --20221107 LHQ 过滤902结尾的机构号
       AND A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '跑批正确：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --表分析
    V_STEP := 3;
    V_STEP_DESC := '表分析开始';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_DBMS_STATS(V_P_DATE,V_TABLE_NAME,V_PARTITION_NAME,O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '跑批正确：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  END IF;

  V_STEP := 4;
  V_STEP_DESC := '跑批结束';
  V_STARTTIME := SYSDATE;
  --在过程跑批完成记录表中插入记录，调度查询该表判断过程是是否跑批完成
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '跑批正确：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

EXCEPTION
  WHEN OTHERS THEN
    O_ERRCODE := '1'; --将SQL错误编号赋植给O_ERRCODE
    V_SQLMSG  := '跑批错误：['||SQLCODE||'],描述信息：'||SQLERRM;
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_EAST5_101_JGXXB;
/

