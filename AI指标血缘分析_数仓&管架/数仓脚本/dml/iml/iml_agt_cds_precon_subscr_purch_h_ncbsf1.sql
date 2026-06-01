/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_cds_precon_subscr_purch_h_ncbsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_cds_precon_subscr_purch_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_cds_precon_subscr_purch_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cds_precon_subscr_purch_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_cds_precon_subscr_purch_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_cds_precon_subscr_purch_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_cds_precon_subscr_purch_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cds_precon_subscr_purch_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,seq_num -- 序号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,precon_subscr_way_cd -- 预约认购方式代码
    ,precon_id -- 预约编号
    ,acct_id -- 账户编号
    ,lmt_id -- 限制编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cert_cty_rg_cd -- 发证国家和地区代码
    ,cust_cn_name -- 客户中文名称
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,pd_prod_precon_status_cd -- 期次产品预约状态代码
    ,pd_cd -- 期次编号
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,issue_termnt_dt -- 发行终止日期
    ,issue_begin_dt -- 发行起始日期
    ,open_acct_dt -- 开户日期
    ,precon_rgst_dt -- 预约登记日期
    ,precon_open_acct_dt -- 预约开户日期
    ,aval_amt_cfg_org_id -- 可用金额配置机构编号
    ,precon_subscr_org_id -- 预约认购机构编号
    ,tran_ref_no -- 交易参考号
    ,pd_issue_amt -- 期次发行金额
    ,precon_amt -- 预约金额
    ,curr_cd -- 币种代码
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,exec_int_rat -- 执行利率
    ,int_rat_type_cd -- 利率类型代码
    ,chn_id -- 渠道编号
    ,del_dt -- 删除日期
    ,del_rs -- 删除原因
    ,fail_rs -- 失败原因
    ,tran_memo_descb -- 交易摘要描述
    ,auth_teller_id -- 授权柜员编号
    ,del_auth_teller_id -- 删除授权柜员编号
    ,del_teller_id -- 删除柜员编号
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cds_precon_subscr_purch_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_cds_precon_subscr_purch_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cds_precon_subscr_purch_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_cds_precon_subscr_purch_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cds_precon_subscr_purch_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_dc_precontract_info-1
insert into ${iml_schema}.agt_cds_precon_subscr_purch_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,seq_num -- 序号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,precon_subscr_way_cd -- 预约认购方式代码
    ,precon_id -- 预约编号
    ,acct_id -- 账户编号
    ,lmt_id -- 限制编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cert_cty_rg_cd -- 发证国家和地区代码
    ,cust_cn_name -- 客户中文名称
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,pd_prod_precon_status_cd -- 期次产品预约状态代码
    ,pd_cd -- 期次编号
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,issue_termnt_dt -- 发行终止日期
    ,issue_begin_dt -- 发行起始日期
    ,open_acct_dt -- 开户日期
    ,precon_rgst_dt -- 预约登记日期
    ,precon_open_acct_dt -- 预约开户日期
    ,aval_amt_cfg_org_id -- 可用金额配置机构编号
    ,precon_subscr_org_id -- 预约认购机构编号
    ,tran_ref_no -- 交易参考号
    ,pd_issue_amt -- 期次发行金额
    ,precon_amt -- 预约金额
    ,curr_cd -- 币种代码
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,exec_int_rat -- 执行利率
    ,int_rat_type_cd -- 利率类型代码
    ,chn_id -- 渠道编号
    ,del_dt -- 删除日期
    ,del_rs -- 删除原因
    ,fail_rs -- 失败原因
    ,tran_memo_descb -- 交易摘要描述
    ,auth_teller_id -- 授权柜员编号
    ,del_auth_teller_id -- 删除授权柜员编号
    ,del_teller_id -- 删除柜员编号
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101039'||P1.PRECONTRACT_NO||P1.SEQ_NO -- 协议编号
    ,P1.SEQ_NO -- 序号
    ,'9999' -- 法人编号
    ,P1.CLIENT_NO -- 客户编号
    ,nvl(trim(P1.PRECONTRACT_STYPE),'-') -- 预约认购方式代码
    ,P1.PRECONTRACT_NO -- 预约编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.RES_SEQ_NO -- 限制编号
    ,P1.DOCUMENT_ID -- 证件号码
    ,nvl(trim(P1.DOCUMENT_TYPE),'0000') -- 证件类型代码
    ,nvl(trim(P1.ISS_COUNTRY),'0000') -- 发证国家和地区代码
    ,P1.CH_CLIENT_NAME -- 客户中文名称
    ,P1.CLIENT_NAME -- 客户名称
    ,P1.PROD_TYPE -- 产品编号
    ,nvl(trim(P1.PRECONTRACT_STATUS),'-') -- 期次产品预约状态代码
    ,P1.STAGE_CODE -- 期次编号
    ,P1.STAGE_PROD_CLASS -- 期次产品类别代码
    ,P1.ISSUE_END_DATE -- 发行终止日期
    ,P1.ISSUE_START_DATE -- 发行起始日期
    ,P1.OPEN_DATE -- 开户日期
    ,P1.PRECONTRACT_DATE -- 预约登记日期
    ,P1.PRECONTRACT_OPEN_DATE -- 预约开户日期
    ,P1.PRECONTRACT_AMT_BRANCH -- 可用金额配置机构编号
    ,P1.PRECONTRACT_BRANCH -- 预约认购机构编号
    ,P1.REFERENCE -- 交易参考号
    ,P1.ISSUE_AMT -- 期次发行金额
    ,P1.PRECONTRACT_AMT -- 预约金额
    ,nvl(trim(P1.PRECONTRACT_CCY),'-') -- 币种代码
    ,P1.ACTUAL_RATE -- 行内利率
    ,P1.FLOAT_RATE -- 浮动利率
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.INT_CALC_TYPE END -- 利率调整方式代码
    ,P1.REAL_RATE -- 执行利率
    ,nvl(trim(P1.INT_TYPE),'-') -- 利率类型代码
    ,nvl(trim(P1.SOURCE_TYPE),'-') -- 渠道编号
    ,P1.DELETE_DATE -- 删除日期
    ,P1.DEL_REASON -- 删除原因
    ,P1.FAILURE_REASON -- 失败原因
    ,P1.NARRATIVE -- 交易摘要描述
    ,P1.AUTH_USER_ID -- 授权柜员编号
    ,P1.DEL_AUTH_USER_ID -- 删除授权柜员编号
    ,P1.DEL_USER_ID -- 删除柜员编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.USER_ID -- 交易柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_dc_precontract_info' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_dc_precontract_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.INT_CALC_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NCBS'
        AND R1.SRC_TAB_EN_NAME= 'NCBS_RB_DC_PRECONTRACT_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'INT_CALC_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_CDS_PRECON_SUBSCR_PURCH_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_ADJ_WAY_CD'
where  1 = 1 
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_cds_precon_subscr_purch_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,seq_num
  	                                        ,lp_id
  	                                        ,cust_id
  	                                        ,precon_subscr_way_cd
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_cds_precon_subscr_purch_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,seq_num -- 序号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,precon_subscr_way_cd -- 预约认购方式代码
    ,precon_id -- 预约编号
    ,acct_id -- 账户编号
    ,lmt_id -- 限制编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cert_cty_rg_cd -- 发证国家和地区代码
    ,cust_cn_name -- 客户中文名称
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,pd_prod_precon_status_cd -- 期次产品预约状态代码
    ,pd_cd -- 期次编号
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,issue_termnt_dt -- 发行终止日期
    ,issue_begin_dt -- 发行起始日期
    ,open_acct_dt -- 开户日期
    ,precon_rgst_dt -- 预约登记日期
    ,precon_open_acct_dt -- 预约开户日期
    ,aval_amt_cfg_org_id -- 可用金额配置机构编号
    ,precon_subscr_org_id -- 预约认购机构编号
    ,tran_ref_no -- 交易参考号
    ,pd_issue_amt -- 期次发行金额
    ,precon_amt -- 预约金额
    ,curr_cd -- 币种代码
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,exec_int_rat -- 执行利率
    ,int_rat_type_cd -- 利率类型代码
    ,chn_id -- 渠道编号
    ,del_dt -- 删除日期
    ,del_rs -- 删除原因
    ,fail_rs -- 失败原因
    ,tran_memo_descb -- 交易摘要描述
    ,auth_teller_id -- 授权柜员编号
    ,del_auth_teller_id -- 删除授权柜员编号
    ,del_teller_id -- 删除柜员编号
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cds_precon_subscr_purch_h_ncbsf1_op(
            agt_id -- 协议编号
    ,seq_num -- 序号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,precon_subscr_way_cd -- 预约认购方式代码
    ,precon_id -- 预约编号
    ,acct_id -- 账户编号
    ,lmt_id -- 限制编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cert_cty_rg_cd -- 发证国家和地区代码
    ,cust_cn_name -- 客户中文名称
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,pd_prod_precon_status_cd -- 期次产品预约状态代码
    ,pd_cd -- 期次编号
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,issue_termnt_dt -- 发行终止日期
    ,issue_begin_dt -- 发行起始日期
    ,open_acct_dt -- 开户日期
    ,precon_rgst_dt -- 预约登记日期
    ,precon_open_acct_dt -- 预约开户日期
    ,aval_amt_cfg_org_id -- 可用金额配置机构编号
    ,precon_subscr_org_id -- 预约认购机构编号
    ,tran_ref_no -- 交易参考号
    ,pd_issue_amt -- 期次发行金额
    ,precon_amt -- 预约金额
    ,curr_cd -- 币种代码
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,exec_int_rat -- 执行利率
    ,int_rat_type_cd -- 利率类型代码
    ,chn_id -- 渠道编号
    ,del_dt -- 删除日期
    ,del_rs -- 删除原因
    ,fail_rs -- 失败原因
    ,tran_memo_descb -- 交易摘要描述
    ,auth_teller_id -- 授权柜员编号
    ,del_auth_teller_id -- 删除授权柜员编号
    ,del_teller_id -- 删除柜员编号
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.precon_subscr_way_cd, o.precon_subscr_way_cd) as precon_subscr_way_cd -- 预约认购方式代码
    ,nvl(n.precon_id, o.precon_id) as precon_id -- 预约编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.lmt_id, o.lmt_id) as lmt_id -- 限制编号
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_cty_rg_cd, o.cert_cty_rg_cd) as cert_cty_rg_cd -- 发证国家和地区代码
    ,nvl(n.cust_cn_name, o.cust_cn_name) as cust_cn_name -- 客户中文名称
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.pd_prod_precon_status_cd, o.pd_prod_precon_status_cd) as pd_prod_precon_status_cd -- 期次产品预约状态代码
    ,nvl(n.pd_cd, o.pd_cd) as pd_cd -- 期次编号
    ,nvl(n.pd_prod_cate_cd, o.pd_prod_cate_cd) as pd_prod_cate_cd -- 期次产品类别代码
    ,nvl(n.issue_termnt_dt, o.issue_termnt_dt) as issue_termnt_dt -- 发行终止日期
    ,nvl(n.issue_begin_dt, o.issue_begin_dt) as issue_begin_dt -- 发行起始日期
    ,nvl(n.open_acct_dt, o.open_acct_dt) as open_acct_dt -- 开户日期
    ,nvl(n.precon_rgst_dt, o.precon_rgst_dt) as precon_rgst_dt -- 预约登记日期
    ,nvl(n.precon_open_acct_dt, o.precon_open_acct_dt) as precon_open_acct_dt -- 预约开户日期
    ,nvl(n.aval_amt_cfg_org_id, o.aval_amt_cfg_org_id) as aval_amt_cfg_org_id -- 可用金额配置机构编号
    ,nvl(n.precon_subscr_org_id, o.precon_subscr_org_id) as precon_subscr_org_id -- 预约认购机构编号
    ,nvl(n.tran_ref_no, o.tran_ref_no) as tran_ref_no -- 交易参考号
    ,nvl(n.pd_issue_amt, o.pd_issue_amt) as pd_issue_amt -- 期次发行金额
    ,nvl(n.precon_amt, o.precon_amt) as precon_amt -- 预约金额
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.bank_int_int_rat, o.bank_int_int_rat) as bank_int_int_rat -- 行内利率
    ,nvl(n.float_int_rat, o.float_int_rat) as float_int_rat -- 浮动利率
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.int_rat_type_cd, o.int_rat_type_cd) as int_rat_type_cd -- 利率类型代码
    ,nvl(n.chn_id, o.chn_id) as chn_id -- 渠道编号
    ,nvl(n.del_dt, o.del_dt) as del_dt -- 删除日期
    ,nvl(n.del_rs, o.del_rs) as del_rs -- 删除原因
    ,nvl(n.fail_rs, o.fail_rs) as fail_rs -- 失败原因
    ,nvl(n.tran_memo_descb, o.tran_memo_descb) as tran_memo_descb -- 交易摘要描述
    ,nvl(n.auth_teller_id, o.auth_teller_id) as auth_teller_id -- 授权柜员编号
    ,nvl(n.del_auth_teller_id, o.del_auth_teller_id) as del_auth_teller_id -- 删除授权柜员编号
    ,nvl(n.del_teller_id, o.del_teller_id) as del_teller_id -- 删除柜员编号
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,case when
            n.agt_id is null
            and n.seq_num is null
            and n.lp_id is null
            and n.cust_id is null
            and n.precon_subscr_way_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.seq_num is null
            and n.lp_id is null
            and n.cust_id is null
            and n.precon_subscr_way_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.seq_num is null
            and n.lp_id is null
            and n.cust_id is null
            and n.precon_subscr_way_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cds_precon_subscr_purch_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_cds_precon_subscr_purch_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.seq_num = n.seq_num
            and o.lp_id = n.lp_id
            and o.cust_id = n.cust_id
            and o.precon_subscr_way_cd = n.precon_subscr_way_cd
where (
        o.agt_id is null
        and o.seq_num is null
        and o.lp_id is null
        and o.cust_id is null
        and o.precon_subscr_way_cd is null
    )
    or (
        n.agt_id is null
        and n.seq_num is null
        and n.lp_id is null
        and n.cust_id is null
        and n.precon_subscr_way_cd is null
    )
    or (
        o.precon_id <> n.precon_id
        or o.acct_id <> n.acct_id
        or o.lmt_id <> n.lmt_id
        or o.cert_no <> n.cert_no
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_cty_rg_cd <> n.cert_cty_rg_cd
        or o.cust_cn_name <> n.cust_cn_name
        or o.cust_name <> n.cust_name
        or o.prod_id <> n.prod_id
        or o.pd_prod_precon_status_cd <> n.pd_prod_precon_status_cd
        or o.pd_cd <> n.pd_cd
        or o.pd_prod_cate_cd <> n.pd_prod_cate_cd
        or o.issue_termnt_dt <> n.issue_termnt_dt
        or o.issue_begin_dt <> n.issue_begin_dt
        or o.open_acct_dt <> n.open_acct_dt
        or o.precon_rgst_dt <> n.precon_rgst_dt
        or o.precon_open_acct_dt <> n.precon_open_acct_dt
        or o.aval_amt_cfg_org_id <> n.aval_amt_cfg_org_id
        or o.precon_subscr_org_id <> n.precon_subscr_org_id
        or o.tran_ref_no <> n.tran_ref_no
        or o.pd_issue_amt <> n.pd_issue_amt
        or o.precon_amt <> n.precon_amt
        or o.curr_cd <> n.curr_cd
        or o.bank_int_int_rat <> n.bank_int_int_rat
        or o.float_int_rat <> n.float_int_rat
        or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
        or o.exec_int_rat <> n.exec_int_rat
        or o.int_rat_type_cd <> n.int_rat_type_cd
        or o.chn_id <> n.chn_id
        or o.del_dt <> n.del_dt
        or o.del_rs <> n.del_rs
        or o.fail_rs <> n.fail_rs
        or o.tran_memo_descb <> n.tran_memo_descb
        or o.auth_teller_id <> n.auth_teller_id
        or o.del_auth_teller_id <> n.del_auth_teller_id
        or o.del_teller_id <> n.del_teller_id
        or o.tran_tm <> n.tran_tm
        or o.tran_teller_id <> n.tran_teller_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_cds_precon_subscr_purch_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,seq_num -- 序号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,precon_subscr_way_cd -- 预约认购方式代码
    ,precon_id -- 预约编号
    ,acct_id -- 账户编号
    ,lmt_id -- 限制编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cert_cty_rg_cd -- 发证国家和地区代码
    ,cust_cn_name -- 客户中文名称
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,pd_prod_precon_status_cd -- 期次产品预约状态代码
    ,pd_cd -- 期次编号
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,issue_termnt_dt -- 发行终止日期
    ,issue_begin_dt -- 发行起始日期
    ,open_acct_dt -- 开户日期
    ,precon_rgst_dt -- 预约登记日期
    ,precon_open_acct_dt -- 预约开户日期
    ,aval_amt_cfg_org_id -- 可用金额配置机构编号
    ,precon_subscr_org_id -- 预约认购机构编号
    ,tran_ref_no -- 交易参考号
    ,pd_issue_amt -- 期次发行金额
    ,precon_amt -- 预约金额
    ,curr_cd -- 币种代码
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,exec_int_rat -- 执行利率
    ,int_rat_type_cd -- 利率类型代码
    ,chn_id -- 渠道编号
    ,del_dt -- 删除日期
    ,del_rs -- 删除原因
    ,fail_rs -- 失败原因
    ,tran_memo_descb -- 交易摘要描述
    ,auth_teller_id -- 授权柜员编号
    ,del_auth_teller_id -- 删除授权柜员编号
    ,del_teller_id -- 删除柜员编号
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cds_precon_subscr_purch_h_ncbsf1_op(
            agt_id -- 协议编号
    ,seq_num -- 序号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,precon_subscr_way_cd -- 预约认购方式代码
    ,precon_id -- 预约编号
    ,acct_id -- 账户编号
    ,lmt_id -- 限制编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cert_cty_rg_cd -- 发证国家和地区代码
    ,cust_cn_name -- 客户中文名称
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,pd_prod_precon_status_cd -- 期次产品预约状态代码
    ,pd_cd -- 期次编号
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,issue_termnt_dt -- 发行终止日期
    ,issue_begin_dt -- 发行起始日期
    ,open_acct_dt -- 开户日期
    ,precon_rgst_dt -- 预约登记日期
    ,precon_open_acct_dt -- 预约开户日期
    ,aval_amt_cfg_org_id -- 可用金额配置机构编号
    ,precon_subscr_org_id -- 预约认购机构编号
    ,tran_ref_no -- 交易参考号
    ,pd_issue_amt -- 期次发行金额
    ,precon_amt -- 预约金额
    ,curr_cd -- 币种代码
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,exec_int_rat -- 执行利率
    ,int_rat_type_cd -- 利率类型代码
    ,chn_id -- 渠道编号
    ,del_dt -- 删除日期
    ,del_rs -- 删除原因
    ,fail_rs -- 失败原因
    ,tran_memo_descb -- 交易摘要描述
    ,auth_teller_id -- 授权柜员编号
    ,del_auth_teller_id -- 删除授权柜员编号
    ,del_teller_id -- 删除柜员编号
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.seq_num -- 序号
    ,o.lp_id -- 法人编号
    ,o.cust_id -- 客户编号
    ,o.precon_subscr_way_cd -- 预约认购方式代码
    ,o.precon_id -- 预约编号
    ,o.acct_id -- 账户编号
    ,o.lmt_id -- 限制编号
    ,o.cert_no -- 证件号码
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_cty_rg_cd -- 发证国家和地区代码
    ,o.cust_cn_name -- 客户中文名称
    ,o.cust_name -- 客户名称
    ,o.prod_id -- 产品编号
    ,o.pd_prod_precon_status_cd -- 期次产品预约状态代码
    ,o.pd_cd -- 期次编号
    ,o.pd_prod_cate_cd -- 期次产品类别代码
    ,o.issue_termnt_dt -- 发行终止日期
    ,o.issue_begin_dt -- 发行起始日期
    ,o.open_acct_dt -- 开户日期
    ,o.precon_rgst_dt -- 预约登记日期
    ,o.precon_open_acct_dt -- 预约开户日期
    ,o.aval_amt_cfg_org_id -- 可用金额配置机构编号
    ,o.precon_subscr_org_id -- 预约认购机构编号
    ,o.tran_ref_no -- 交易参考号
    ,o.pd_issue_amt -- 期次发行金额
    ,o.precon_amt -- 预约金额
    ,o.curr_cd -- 币种代码
    ,o.bank_int_int_rat -- 行内利率
    ,o.float_int_rat -- 浮动利率
    ,o.int_rat_adj_way_cd -- 利率调整方式代码
    ,o.exec_int_rat -- 执行利率
    ,o.int_rat_type_cd -- 利率类型代码
    ,o.chn_id -- 渠道编号
    ,o.del_dt -- 删除日期
    ,o.del_rs -- 删除原因
    ,o.fail_rs -- 失败原因
    ,o.tran_memo_descb -- 交易摘要描述
    ,o.auth_teller_id -- 授权柜员编号
    ,o.del_auth_teller_id -- 删除授权柜员编号
    ,o.del_teller_id -- 删除柜员编号
    ,o.tran_tm -- 交易时间
    ,o.tran_teller_id -- 交易柜员编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cds_precon_subscr_purch_h_ncbsf1_bk o
    left join ${iml_schema}.agt_cds_precon_subscr_purch_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.seq_num = n.seq_num
            and o.lp_id = n.lp_id
            and o.cust_id = n.cust_id
            and o.precon_subscr_way_cd = n.precon_subscr_way_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_cds_precon_subscr_purch_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.seq_num = d.seq_num
            and o.lp_id = d.lp_id
            and o.cust_id = d.cust_id
            and o.precon_subscr_way_cd = d.precon_subscr_way_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_cds_precon_subscr_purch_h;
--alter table ${iml_schema}.agt_cds_precon_subscr_purch_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_cds_precon_subscr_purch_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_cds_precon_subscr_purch_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_cds_precon_subscr_purch_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_cds_precon_subscr_purch_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_cds_precon_subscr_purch_h_ncbsf1_cl;
alter table ${iml_schema}.agt_cds_precon_subscr_purch_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_cds_precon_subscr_purch_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_cds_precon_subscr_purch_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_cds_precon_subscr_purch_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_cds_precon_subscr_purch_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_cds_precon_subscr_purch_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_cds_precon_subscr_purch_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_cds_precon_subscr_purch_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
