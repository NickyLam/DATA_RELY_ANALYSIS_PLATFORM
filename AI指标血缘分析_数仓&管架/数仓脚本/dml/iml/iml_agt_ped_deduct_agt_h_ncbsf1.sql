/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ped_deduct_agt_h_ncbsf1
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
alter table ${iml_schema}.agt_ped_deduct_agt_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ped_deduct_agt_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ped_deduct_agt_h partition for ('ncbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_ped_deduct_agt_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_ped_deduct_agt_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_ped_deduct_agt_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ped_deduct_agt_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_agt_id -- 存款协议编号
    ,acct_id -- 账户编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,tran_org_id -- 交易机构编号
    ,valid_dt -- 有效日期
    ,invalid_dt -- 失效日期
    ,sign_agt_status_cd -- 签约协议状态代码
    ,deduct_type_cd -- 扣划类型代码
    ,can_deduct_tot_amt -- 可扣划总金额
    ,can_deduct_tot_cnt -- 可扣划总次数
    ,lmt_id -- 限制编号
    ,freq_cd -- 频率代码
    ,aldy_deduct_cnt -- 已扣划次数
    ,next_proc_dt -- 下一处理日期
    ,benefc_curr_cd -- 受益人币种代码
    ,aldy_deduct_tot_amt -- 已扣划总金额
    ,deduct_flg -- 扣划标志
    ,benefc_cust_acct_num -- 受益人客户账号
    ,benefc_prod_id -- 受益人产品编号
    ,benefc_sub_acct_num -- 受益人子账号
    ,benefc_acct_acct_name -- 受益人账户户名
    ,have_prvlg_org_name -- 有权限机关名称
    ,law_doc_num -- 法律文书号码
    ,enforc_ps_1_name -- 执法人1名称
    ,enforc_ps_1_cert_type_cd -- 执法人1证件类型代码
    ,enforc_ps_1_cert_no -- 执法人1证件号码
    ,enforc_ps_2_name -- 执法人2名称
    ,enforc_ps_2_cert_type_cd -- 执法人2证件类型代码
    ,enforc_ps_2_cert_no -- 执法人2证件号码
    ,tran_memo_descb -- 交易摘要描述
    ,auth_teller_id -- 授权柜员编号
    ,cust_id -- 客户编号
    ,tran_teller_id -- 交易柜员编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ped_deduct_agt_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_ped_deduct_agt_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ped_deduct_agt_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_ped_deduct_agt_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ped_deduct_agt_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_agreement_impound-1
insert into ${iml_schema}.agt_ped_deduct_agt_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_agt_id -- 存款协议编号
    ,acct_id -- 账户编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,tran_org_id -- 交易机构编号
    ,valid_dt -- 有效日期
    ,invalid_dt -- 失效日期
    ,sign_agt_status_cd -- 签约协议状态代码
    ,deduct_type_cd -- 扣划类型代码
    ,can_deduct_tot_amt -- 可扣划总金额
    ,can_deduct_tot_cnt -- 可扣划总次数
    ,lmt_id -- 限制编号
    ,freq_cd -- 频率代码
    ,aldy_deduct_cnt -- 已扣划次数
    ,next_proc_dt -- 下一处理日期
    ,benefc_curr_cd -- 受益人币种代码
    ,aldy_deduct_tot_amt -- 已扣划总金额
    ,deduct_flg -- 扣划标志
    ,benefc_cust_acct_num -- 受益人客户账号
    ,benefc_prod_id -- 受益人产品编号
    ,benefc_sub_acct_num -- 受益人子账号
    ,benefc_acct_acct_name -- 受益人账户户名
    ,have_prvlg_org_name -- 有权限机关名称
    ,law_doc_num -- 法律文书号码
    ,enforc_ps_1_name -- 执法人1名称
    ,enforc_ps_1_cert_type_cd -- 执法人1证件类型代码
    ,enforc_ps_1_cert_no -- 执法人1证件号码
    ,enforc_ps_2_name -- 执法人2名称
    ,enforc_ps_2_cert_type_cd -- 执法人2证件类型代码
    ,enforc_ps_2_cert_no -- 执法人2证件号码
    ,tran_memo_descb -- 交易摘要描述
    ,auth_teller_id -- 授权柜员编号
    ,cust_id -- 客户编号
    ,tran_teller_id -- 交易柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300003'||P1.AGREEMENT_ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.AGREEMENT_ID -- 存款协议编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.AGREEMENT_TYPE -- 签约协议类型代码
    ,P1.BASE_ACCT_NO -- 客户账号
    ,P1.PROD_TYPE -- 产品编号
    ,P1.CCY -- 币种代码
    ,P1.ACCT_SEQ_NO -- 子账号
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,P1.START_DATE -- 有效日期
    ,P1.END_DATE -- 失效日期
    ,P1.AGREEMENT_STATUS -- 签约协议状态代码
    ,P1.IMPOUND_TYPE -- 扣划类型代码
    ,P1.TOTAL_AMT -- 可扣划总金额
    ,P1.TOTAL_TIMES -- 可扣划总次数
    ,P1.RES_SEQ_NO -- 限制编号
    ,P1.PERIOD_FREQ -- 频率代码
    ,P1.TRANSFER_TIMES -- 已扣划次数
    ,P1.NEXT_DEAL_DATE -- 下一处理日期
    ,P1.BENENFIT_CCY -- 受益人币种代码
    ,P1.IMPOUND_TOTAL_AMT -- 已扣划总金额
    ,DECODE(P1.IMPOUND_END_FLAG,'Y','1','N','0') -- 扣划标志
    ,P1.BENEFIT_BASE_ACCT_NO -- 受益人客户账号
    ,P1.BENEFIT_PROD_TYPE -- 受益人产品编号
    ,P1.BENENFIT_SEQ_NO -- 受益人子账号
    ,P1.BENENFIT_ACCT_NAME -- 受益人账户户名
    ,P1.DEDUCTION_JUDICIARY_NAME -- 有权限机关名称
    ,P1.LAW_NO -- 法律文书号码
    ,P1.JUDICIARY_OFFICER_NAME -- 执法人1名称
    ,P1.JUDICIARY_DOCUMENT_TYPE -- 执法人1证件类型代码
    ,P1.JUDICIARY_DOCUMENT_ID -- 执法人1证件号码
    ,P1.JUDICIARY_OTH_OFFICER_NAME -- 执法人2名称
    ,P1.JUDICIARY_OTH_DOCUMENT_TYPE -- 执法人2证件类型代码
    ,P1.JUDICIARY_OTH_DOCUMENT_ID -- 执法人2证件号码
    ,P1.NARRATIVE -- 交易摘要描述
    ,P1.AUTH_USER_ID -- 授权柜员编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.USER_ID -- 交易柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_agreement_impound' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_agreement_impound p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_ped_deduct_agt_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,dep_agt_id
  	                                        ,acct_id
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
        into ${iml_schema}.agt_ped_deduct_agt_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_agt_id -- 存款协议编号
    ,acct_id -- 账户编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,tran_org_id -- 交易机构编号
    ,valid_dt -- 有效日期
    ,invalid_dt -- 失效日期
    ,sign_agt_status_cd -- 签约协议状态代码
    ,deduct_type_cd -- 扣划类型代码
    ,can_deduct_tot_amt -- 可扣划总金额
    ,can_deduct_tot_cnt -- 可扣划总次数
    ,lmt_id -- 限制编号
    ,freq_cd -- 频率代码
    ,aldy_deduct_cnt -- 已扣划次数
    ,next_proc_dt -- 下一处理日期
    ,benefc_curr_cd -- 受益人币种代码
    ,aldy_deduct_tot_amt -- 已扣划总金额
    ,deduct_flg -- 扣划标志
    ,benefc_cust_acct_num -- 受益人客户账号
    ,benefc_prod_id -- 受益人产品编号
    ,benefc_sub_acct_num -- 受益人子账号
    ,benefc_acct_acct_name -- 受益人账户户名
    ,have_prvlg_org_name -- 有权限机关名称
    ,law_doc_num -- 法律文书号码
    ,enforc_ps_1_name -- 执法人1名称
    ,enforc_ps_1_cert_type_cd -- 执法人1证件类型代码
    ,enforc_ps_1_cert_no -- 执法人1证件号码
    ,enforc_ps_2_name -- 执法人2名称
    ,enforc_ps_2_cert_type_cd -- 执法人2证件类型代码
    ,enforc_ps_2_cert_no -- 执法人2证件号码
    ,tran_memo_descb -- 交易摘要描述
    ,auth_teller_id -- 授权柜员编号
    ,cust_id -- 客户编号
    ,tran_teller_id -- 交易柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ped_deduct_agt_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_agt_id -- 存款协议编号
    ,acct_id -- 账户编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,tran_org_id -- 交易机构编号
    ,valid_dt -- 有效日期
    ,invalid_dt -- 失效日期
    ,sign_agt_status_cd -- 签约协议状态代码
    ,deduct_type_cd -- 扣划类型代码
    ,can_deduct_tot_amt -- 可扣划总金额
    ,can_deduct_tot_cnt -- 可扣划总次数
    ,lmt_id -- 限制编号
    ,freq_cd -- 频率代码
    ,aldy_deduct_cnt -- 已扣划次数
    ,next_proc_dt -- 下一处理日期
    ,benefc_curr_cd -- 受益人币种代码
    ,aldy_deduct_tot_amt -- 已扣划总金额
    ,deduct_flg -- 扣划标志
    ,benefc_cust_acct_num -- 受益人客户账号
    ,benefc_prod_id -- 受益人产品编号
    ,benefc_sub_acct_num -- 受益人子账号
    ,benefc_acct_acct_name -- 受益人账户户名
    ,have_prvlg_org_name -- 有权限机关名称
    ,law_doc_num -- 法律文书号码
    ,enforc_ps_1_name -- 执法人1名称
    ,enforc_ps_1_cert_type_cd -- 执法人1证件类型代码
    ,enforc_ps_1_cert_no -- 执法人1证件号码
    ,enforc_ps_2_name -- 执法人2名称
    ,enforc_ps_2_cert_type_cd -- 执法人2证件类型代码
    ,enforc_ps_2_cert_no -- 执法人2证件号码
    ,tran_memo_descb -- 交易摘要描述
    ,auth_teller_id -- 授权柜员编号
    ,cust_id -- 客户编号
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
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.dep_agt_id, o.dep_agt_id) as dep_agt_id -- 存款协议编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.sign_agt_type_cd, o.sign_agt_type_cd) as sign_agt_type_cd -- 签约协议类型代码
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.sub_acct_num, o.sub_acct_num) as sub_acct_num -- 子账号
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.valid_dt, o.valid_dt) as valid_dt -- 有效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.sign_agt_status_cd, o.sign_agt_status_cd) as sign_agt_status_cd -- 签约协议状态代码
    ,nvl(n.deduct_type_cd, o.deduct_type_cd) as deduct_type_cd -- 扣划类型代码
    ,nvl(n.can_deduct_tot_amt, o.can_deduct_tot_amt) as can_deduct_tot_amt -- 可扣划总金额
    ,nvl(n.can_deduct_tot_cnt, o.can_deduct_tot_cnt) as can_deduct_tot_cnt -- 可扣划总次数
    ,nvl(n.lmt_id, o.lmt_id) as lmt_id -- 限制编号
    ,nvl(n.freq_cd, o.freq_cd) as freq_cd -- 频率代码
    ,nvl(n.aldy_deduct_cnt, o.aldy_deduct_cnt) as aldy_deduct_cnt -- 已扣划次数
    ,nvl(n.next_proc_dt, o.next_proc_dt) as next_proc_dt -- 下一处理日期
    ,nvl(n.benefc_curr_cd, o.benefc_curr_cd) as benefc_curr_cd -- 受益人币种代码
    ,nvl(n.aldy_deduct_tot_amt, o.aldy_deduct_tot_amt) as aldy_deduct_tot_amt -- 已扣划总金额
    ,nvl(n.deduct_flg, o.deduct_flg) as deduct_flg -- 扣划标志
    ,nvl(n.benefc_cust_acct_num, o.benefc_cust_acct_num) as benefc_cust_acct_num -- 受益人客户账号
    ,nvl(n.benefc_prod_id, o.benefc_prod_id) as benefc_prod_id -- 受益人产品编号
    ,nvl(n.benefc_sub_acct_num, o.benefc_sub_acct_num) as benefc_sub_acct_num -- 受益人子账号
    ,nvl(n.benefc_acct_acct_name, o.benefc_acct_acct_name) as benefc_acct_acct_name -- 受益人账户户名
    ,nvl(n.have_prvlg_org_name, o.have_prvlg_org_name) as have_prvlg_org_name -- 有权限机关名称
    ,nvl(n.law_doc_num, o.law_doc_num) as law_doc_num -- 法律文书号码
    ,nvl(n.enforc_ps_1_name, o.enforc_ps_1_name) as enforc_ps_1_name -- 执法人1名称
    ,nvl(n.enforc_ps_1_cert_type_cd, o.enforc_ps_1_cert_type_cd) as enforc_ps_1_cert_type_cd -- 执法人1证件类型代码
    ,nvl(n.enforc_ps_1_cert_no, o.enforc_ps_1_cert_no) as enforc_ps_1_cert_no -- 执法人1证件号码
    ,nvl(n.enforc_ps_2_name, o.enforc_ps_2_name) as enforc_ps_2_name -- 执法人2名称
    ,nvl(n.enforc_ps_2_cert_type_cd, o.enforc_ps_2_cert_type_cd) as enforc_ps_2_cert_type_cd -- 执法人2证件类型代码
    ,nvl(n.enforc_ps_2_cert_no, o.enforc_ps_2_cert_no) as enforc_ps_2_cert_no -- 执法人2证件号码
    ,nvl(n.tran_memo_descb, o.tran_memo_descb) as tran_memo_descb -- 交易摘要描述
    ,nvl(n.auth_teller_id, o.auth_teller_id) as auth_teller_id -- 授权柜员编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dep_agt_id is null
            and n.acct_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dep_agt_id is null
            and n.acct_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dep_agt_id is null
            and n.acct_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ped_deduct_agt_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_ped_deduct_agt_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.dep_agt_id = n.dep_agt_id
            and o.acct_id = n.acct_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.dep_agt_id is null
        and o.acct_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.dep_agt_id is null
        and n.acct_id is null
    )
    or (
        o.sign_agt_type_cd <> n.sign_agt_type_cd
        or o.cust_acct_num <> n.cust_acct_num
        or o.prod_id <> n.prod_id
        or o.curr_cd <> n.curr_cd
        or o.sub_acct_num <> n.sub_acct_num
        or o.tran_org_id <> n.tran_org_id
        or o.valid_dt <> n.valid_dt
        or o.invalid_dt <> n.invalid_dt
        or o.sign_agt_status_cd <> n.sign_agt_status_cd
        or o.deduct_type_cd <> n.deduct_type_cd
        or o.can_deduct_tot_amt <> n.can_deduct_tot_amt
        or o.can_deduct_tot_cnt <> n.can_deduct_tot_cnt
        or o.lmt_id <> n.lmt_id
        or o.freq_cd <> n.freq_cd
        or o.aldy_deduct_cnt <> n.aldy_deduct_cnt
        or o.next_proc_dt <> n.next_proc_dt
        or o.benefc_curr_cd <> n.benefc_curr_cd
        or o.aldy_deduct_tot_amt <> n.aldy_deduct_tot_amt
        or o.deduct_flg <> n.deduct_flg
        or o.benefc_cust_acct_num <> n.benefc_cust_acct_num
        or o.benefc_prod_id <> n.benefc_prod_id
        or o.benefc_sub_acct_num <> n.benefc_sub_acct_num
        or o.benefc_acct_acct_name <> n.benefc_acct_acct_name
        or o.have_prvlg_org_name <> n.have_prvlg_org_name
        or o.law_doc_num <> n.law_doc_num
        or o.enforc_ps_1_name <> n.enforc_ps_1_name
        or o.enforc_ps_1_cert_type_cd <> n.enforc_ps_1_cert_type_cd
        or o.enforc_ps_1_cert_no <> n.enforc_ps_1_cert_no
        or o.enforc_ps_2_name <> n.enforc_ps_2_name
        or o.enforc_ps_2_cert_type_cd <> n.enforc_ps_2_cert_type_cd
        or o.enforc_ps_2_cert_no <> n.enforc_ps_2_cert_no
        or o.tran_memo_descb <> n.tran_memo_descb
        or o.auth_teller_id <> n.auth_teller_id
        or o.cust_id <> n.cust_id
        or o.tran_teller_id <> n.tran_teller_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_ped_deduct_agt_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_agt_id -- 存款协议编号
    ,acct_id -- 账户编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,tran_org_id -- 交易机构编号
    ,valid_dt -- 有效日期
    ,invalid_dt -- 失效日期
    ,sign_agt_status_cd -- 签约协议状态代码
    ,deduct_type_cd -- 扣划类型代码
    ,can_deduct_tot_amt -- 可扣划总金额
    ,can_deduct_tot_cnt -- 可扣划总次数
    ,lmt_id -- 限制编号
    ,freq_cd -- 频率代码
    ,aldy_deduct_cnt -- 已扣划次数
    ,next_proc_dt -- 下一处理日期
    ,benefc_curr_cd -- 受益人币种代码
    ,aldy_deduct_tot_amt -- 已扣划总金额
    ,deduct_flg -- 扣划标志
    ,benefc_cust_acct_num -- 受益人客户账号
    ,benefc_prod_id -- 受益人产品编号
    ,benefc_sub_acct_num -- 受益人子账号
    ,benefc_acct_acct_name -- 受益人账户户名
    ,have_prvlg_org_name -- 有权限机关名称
    ,law_doc_num -- 法律文书号码
    ,enforc_ps_1_name -- 执法人1名称
    ,enforc_ps_1_cert_type_cd -- 执法人1证件类型代码
    ,enforc_ps_1_cert_no -- 执法人1证件号码
    ,enforc_ps_2_name -- 执法人2名称
    ,enforc_ps_2_cert_type_cd -- 执法人2证件类型代码
    ,enforc_ps_2_cert_no -- 执法人2证件号码
    ,tran_memo_descb -- 交易摘要描述
    ,auth_teller_id -- 授权柜员编号
    ,cust_id -- 客户编号
    ,tran_teller_id -- 交易柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ped_deduct_agt_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_agt_id -- 存款协议编号
    ,acct_id -- 账户编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,tran_org_id -- 交易机构编号
    ,valid_dt -- 有效日期
    ,invalid_dt -- 失效日期
    ,sign_agt_status_cd -- 签约协议状态代码
    ,deduct_type_cd -- 扣划类型代码
    ,can_deduct_tot_amt -- 可扣划总金额
    ,can_deduct_tot_cnt -- 可扣划总次数
    ,lmt_id -- 限制编号
    ,freq_cd -- 频率代码
    ,aldy_deduct_cnt -- 已扣划次数
    ,next_proc_dt -- 下一处理日期
    ,benefc_curr_cd -- 受益人币种代码
    ,aldy_deduct_tot_amt -- 已扣划总金额
    ,deduct_flg -- 扣划标志
    ,benefc_cust_acct_num -- 受益人客户账号
    ,benefc_prod_id -- 受益人产品编号
    ,benefc_sub_acct_num -- 受益人子账号
    ,benefc_acct_acct_name -- 受益人账户户名
    ,have_prvlg_org_name -- 有权限机关名称
    ,law_doc_num -- 法律文书号码
    ,enforc_ps_1_name -- 执法人1名称
    ,enforc_ps_1_cert_type_cd -- 执法人1证件类型代码
    ,enforc_ps_1_cert_no -- 执法人1证件号码
    ,enforc_ps_2_name -- 执法人2名称
    ,enforc_ps_2_cert_type_cd -- 执法人2证件类型代码
    ,enforc_ps_2_cert_no -- 执法人2证件号码
    ,tran_memo_descb -- 交易摘要描述
    ,auth_teller_id -- 授权柜员编号
    ,cust_id -- 客户编号
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
    ,o.lp_id -- 法人编号
    ,o.dep_agt_id -- 存款协议编号
    ,o.acct_id -- 账户编号
    ,o.sign_agt_type_cd -- 签约协议类型代码
    ,o.cust_acct_num -- 客户账号
    ,o.prod_id -- 产品编号
    ,o.curr_cd -- 币种代码
    ,o.sub_acct_num -- 子账号
    ,o.tran_org_id -- 交易机构编号
    ,o.valid_dt -- 有效日期
    ,o.invalid_dt -- 失效日期
    ,o.sign_agt_status_cd -- 签约协议状态代码
    ,o.deduct_type_cd -- 扣划类型代码
    ,o.can_deduct_tot_amt -- 可扣划总金额
    ,o.can_deduct_tot_cnt -- 可扣划总次数
    ,o.lmt_id -- 限制编号
    ,o.freq_cd -- 频率代码
    ,o.aldy_deduct_cnt -- 已扣划次数
    ,o.next_proc_dt -- 下一处理日期
    ,o.benefc_curr_cd -- 受益人币种代码
    ,o.aldy_deduct_tot_amt -- 已扣划总金额
    ,o.deduct_flg -- 扣划标志
    ,o.benefc_cust_acct_num -- 受益人客户账号
    ,o.benefc_prod_id -- 受益人产品编号
    ,o.benefc_sub_acct_num -- 受益人子账号
    ,o.benefc_acct_acct_name -- 受益人账户户名
    ,o.have_prvlg_org_name -- 有权限机关名称
    ,o.law_doc_num -- 法律文书号码
    ,o.enforc_ps_1_name -- 执法人1名称
    ,o.enforc_ps_1_cert_type_cd -- 执法人1证件类型代码
    ,o.enforc_ps_1_cert_no -- 执法人1证件号码
    ,o.enforc_ps_2_name -- 执法人2名称
    ,o.enforc_ps_2_cert_type_cd -- 执法人2证件类型代码
    ,o.enforc_ps_2_cert_no -- 执法人2证件号码
    ,o.tran_memo_descb -- 交易摘要描述
    ,o.auth_teller_id -- 授权柜员编号
    ,o.cust_id -- 客户编号
    ,o.tran_teller_id -- 交易柜员编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ped_deduct_agt_h_ncbsf1_bk o
    left join ${iml_schema}.agt_ped_deduct_agt_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.dep_agt_id = n.dep_agt_id
            and o.acct_id = n.acct_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_ped_deduct_agt_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.dep_agt_id = d.dep_agt_id
            and o.acct_id = d.acct_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_ped_deduct_agt_h;
alter table ${iml_schema}.agt_ped_deduct_agt_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_ped_deduct_agt_h exchange subpartition p_ncbsf1_19000101 with table ${iml_schema}.agt_ped_deduct_agt_h_ncbsf1_cl;
alter table ${iml_schema}.agt_ped_deduct_agt_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_ped_deduct_agt_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ped_deduct_agt_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_ped_deduct_agt_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_ped_deduct_agt_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_ped_deduct_agt_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_ped_deduct_agt_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ped_deduct_agt_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
