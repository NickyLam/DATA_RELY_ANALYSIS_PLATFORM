/*
Purpose:    整全模型层-全量切片脚本，清空目标表当天分区数据，把源表当天数据全量数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_wyd_guar_cont_h_icmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_wyd_guar_cont_h_icmsf1_tm purge;
alter table ${iml_schema}.agt_wyd_guar_cont_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_wyd_guar_cont_h modify partition p_icmsf1
    add subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wyd_guar_cont_h_icmsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,guar_cont_id -- 担保合同编号
    ,prod_id -- 产品编号
    ,level5_cls_cd -- 五级分类代码
    ,curr_cd -- 币种代码
    ,pri_contr_type_cd -- 主合同类型代码
    ,guar_amt -- 担保金额
    ,effect_flg -- 生效标志
    ,sign_dt -- 签约日期
    ,exp_dt -- 到期日期
    ,guar_cont_type_cd -- 担保合同类型代码
    ,cust_id -- 客户编号
    ,guartor_cust_id -- 担保人客户编号
    ,guartor_cust_name -- 担保人客户名称
    ,guartor_cust_type_cd -- 担保人客户类型代码
    ,guartor_cert_type_cd -- 担保人证件类型代码
    ,guartor_cert_no -- 担保人证件号码
    ,guar_form_cd -- 担保形式代码
    ,guar_way_cd -- 担保方式代码
    ,lmt_id -- 额度编号
    ,plat_batch_guar_flg -- 平台批量担保标志
    ,gov_guar_cate_cd -- 政府融资担保类别代码
    ,oper_teller_id -- 经办柜员编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wyd_guar_cont_h
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- icms_wyd_guarantee_cont-1
insert into ${iml_schema}.agt_wyd_guar_cont_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,guar_cont_id -- 担保合同编号
    ,prod_id -- 产品编号
    ,level5_cls_cd -- 五级分类代码
    ,curr_cd -- 币种代码
    ,pri_contr_type_cd -- 主合同类型代码
    ,guar_amt -- 担保金额
    ,effect_flg -- 生效标志
    ,sign_dt -- 签约日期
    ,exp_dt -- 到期日期
    ,guar_cont_type_cd -- 担保合同类型代码
    ,cust_id -- 客户编号
    ,guartor_cust_id -- 担保人客户编号
    ,guartor_cust_name -- 担保人客户名称
    ,guartor_cust_type_cd -- 担保人客户类型代码
    ,guartor_cert_type_cd -- 担保人证件类型代码
    ,guartor_cert_no -- 担保人证件号码
    ,guar_form_cd -- 担保形式代码
    ,guar_way_cd -- 担保方式代码
    ,lmt_id -- 额度编号
    ,plat_batch_guar_flg -- 平台批量担保标志
    ,gov_guar_cate_cd -- 政府融资担保类别代码
    ,oper_teller_id -- 经办柜员编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300065'||P1.GUARCONTRACTNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.GUARCONTRACTNO -- 担保合同编号
    ,P1.PRODUCTID -- 产品编号
    ,nvl(trim(P1.CLASSIFYRESULT),'99') -- 五级分类代码
    ,nvl(trim(P1.CCYCD),'-') -- 币种代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.MAINCONTRACTTYPE END -- 主合同类型代码
    ,P1.GUARAMT -- 担保金额
    ,decode(P1.GUARCONTRACTSTS,'030','0','020','1',' ','-',P1.GUARCONTRACTSTS) -- 生效标志
    ,${iml_schema}.dateformat_min(P1.SIGNDATE) -- 签约日期
    ,${iml_schema}.dateformat_max2(P1.MATURITYDATE) -- 到期日期
    ,nvl(trim(P1.GUARCONTRACTTYPE),'-') -- 担保合同类型代码
    ,P1.CUSTOMERID -- 客户编号
    ,P1.GUARCUSTNO -- 担保人客户编号
    ,P1.GUARCUSTNAME -- 担保人客户名称
    ,nvl(trim(P1.GUARCUSTTYPE),'-') -- 担保人客户类型代码
    ,nvl(trim(P1.GUARCUSTIDTYPE),'0000') -- 担保人证件类型代码
    ,P1.GUARCUSTIDNO -- 担保人证件号码
    ,nvl(trim(P1.GUARANTORTYPE),'-') -- 担保形式代码
    ,nvl(trim(P1.GUARTYPE),'-') -- 担保方式代码
    ,P1.CONTRACTNO -- 额度编号
    ,decode(P1.ISPLATFORMGUAR,'N','0','Y','1',' ','-',P1.ISPLATFORMGUAR) -- 平台批量担保标志
    ,nvl(trim(P1.LOCALGOVGUARTYPE),'-') -- 政府融资担保类别代码
    ,P1.OPERATOR -- 经办柜员编号
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 最后更新柜员编号
    ,P1.UPDATEORGID -- 最后更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_wyd_guarantee_cont' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_wyd_guarantee_cont p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.MAINCONTRACTTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_WYD_GUARANTEE_CONT'
        AND R1.SRC_FIELD_EN_NAME= 'MAINCONTRACTTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_WYD_GUAR_CONT_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PRI_CONTR_TYPE_CD'
where  1 = 1 
    and p1.etl_dt=to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.agt_wyd_guar_cont_h truncate subpartition p_icmsf1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.agt_wyd_guar_cont_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_wyd_guar_cont_h_icmsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_wyd_guar_cont_h to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_wyd_guar_cont_h_icmsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_wyd_guar_cont_h', partname => 'p_icmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);