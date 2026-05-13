CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_DIIS_PDPD01_TO_MDL (I_P_DATE IN INTEGER , O_ERRCODE OUT VARCHAR2)
IS
V_P_DATE  VARCHAR2(8);

BEGIN

EXECUTE IMMEDIATE 'TRUNCATE TABLE DIIS_PDPD01';
V_P_DATE := TO_CHAR(I_P_DATE);
INSERT INTO DIIS_PDPD01
(
          RID               --数据主键
          ,CUST_SEQ         --存款人序号
          ,NAME             --存款人名称
          ,CUST_ID          --识别码
          ,SEX              --性别
          ,NATIONALITY      --国籍
          ,OCCUPATION       --职业
          ,DPST_TOT_AMT     --各存款账户本息合计
          ,ACCT_SEQ         --存款账户序号
          ,PROD_TYPE        --存款产品类别
          ,ACCT_NO          --存款账户号码
          ,ACCT_TYPE        --存款账户类型
          ,DPST_STS         --存款状态
          ,ID_TYPE          --开户证件类型
          ,ID_NO            --开户证件号码
          ,ID_VALID_DT      --开户证件有效期限
          ,TEL_NO           --联系电话
          ,ADDR             --联系地址
          ,PRIN_AMT         --存款本金
          ,INT_AMT          --应付利息
          ,TOT_AMT          --本息合计
          ,NOTE             --备注
          ,DATA_DT          --数据日期
          ,ORG_NO           --机构编号
          ,CURR_CD          --币种
          ,DEPT_NO          --条线
          ,ISSUED_NO        --填报机构
          ,RPT_ORG_NO       --报送机构号
          ,DATA_OURCES      --数据来源
          ,DATA_MODIFY      --数据修改
          ,B_TOT_AMT        --其中:被保险存款本息合计
					,S_TOT_AMT        --其中:受保存款本息合计
					,IS_SEQ           --是否合计项
					,SUBJ_ID          --科目编号
					,INDV_BUS_FLG     --是否个体工商户
					,WEB_BUS_FLG      --是否微众存款
					,DEP_KIND         --储种
					,BASE_CUR         --来源币种
					,DEP_BAL          --折算前存款余额
)
       SELECT
          RID               --数据主键
          ,CUST_SEQ         --存款人序号
          ,NAME             --存款人名称
          ,CUST_ID          --识别码
          ,SEX              --性别
          ,NATIONALITY      --国籍
          ,OCCUPATION       --职业
          ,DPST_TOT_AMT     --各存款账户本息合计
          ,ACCT_SEQ         --存款账户序号
          ,PROD_TYPE        --存款产品类别
          ,ACCT_NO          --存款账户号码
          ,ACCT_TYPE        --存款账户类型
          ,DPST_STS         --存款状态
          ,ID_TYPE          --开户证件类型
          ,ID_NO            --开户证件号码
          ,ID_VALID_DT      --开户证件有效期限
          ,TEL_NO           --联系电话
          ,ADDR             --联系地址
          ,PRIN_AMT         --存款本金
          ,INT_AMT          --应付利息
          ,TOT_AMT          --本息合计
          ,NOTE             --备注
          ,DATA_DT          --数据日期
          ,ORG_NO           --机构编号
          ,CURR_CD          --币种
          ,DEPT_NO          --条线
          ,ISSUED_NO        --填报机构
          ,RPT_ORG_NO       --报送机构号
          ,DATA_OURCES      --数据来源
          ,DATA_MODIFY      --数据修改
          ,B_TOT_AMT        --其中:被保险存款本息合计
					,S_TOT_AMT        --其中:受保存款本息合计
					,IS_SEQ           --是否合计项
					,SUBJ_ID          --科目编号
					,INDV_BUS_FLG     --是否个体工商户
					,WEB_BUS_FLG      --是否微众存款
					,DEP_KIND         --储种
					,BASE_CUR         --来源币种
					,DEP_BAL          --折算前存款余额
FROM  RRP_DIIS.DIIS_PDPD01
WHERE DATA_DT = TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD'),'YYYY-MM-DD')
;
COMMIT;

O_ERRCODE := '0';

END;
/

