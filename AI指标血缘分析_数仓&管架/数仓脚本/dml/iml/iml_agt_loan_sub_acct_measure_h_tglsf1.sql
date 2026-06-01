/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_sub_acct_measure_h_tglsf1
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
alter table ${iml_schema}.agt_loan_sub_acct_measure_h add partition p_tglsf1 values ('tglsf1')(
        subpartition p_tglsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_tglsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_sub_acct_measure_h_tglsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_sub_acct_measure_h partition for ('tglsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_sub_acct_measure_h_tglsf1_tm purge;
drop table ${iml_schema}.agt_loan_sub_acct_measure_h_tglsf1_op purge;
drop table ${iml_schema}.agt_loan_sub_acct_measure_h_tglsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_sub_acct_measure_h_tglsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,sob_id -- 账套编号
    ,src_sys_cd -- 源系统代码
    ,core_loan_num -- 核心贷款号
    ,tran_flow_num -- 交易流水号
    ,sub_tran_cate_cd -- 子交易类别代码
    ,curr_cd -- 币种代码
    ,org_id -- 机构编号
    ,dubil_id -- 借据编号
    ,bus_type_cd -- 业务类型代码
    ,prod_id -- 产品编号
    ,cont_id -- 合同编号
    ,init_loan_num -- 原贷款号
    ,loan_impam_resv_lmt -- 贷款减值准备金额
    ,discnt_int -- 贴现利息
    ,int_income -- 利息收入
    ,nomal_pric -- 正常本金
    ,other_acct_recvbl_impam_resv_lmt -- 其他应收款减值准备金额
    ,output_tax_lmt -- 销项税额
    ,adv_vat_amt -- 代垫增值税金额
    ,wrtn_off_pric -- 已核销本金
    ,wrtn_off_advc_money -- 已核销垫付款
    ,int_recvbl -- 应收利息
    ,acru_aldy_impam_int -- 应计已减值利息
    ,log_pric -- 保函本金
    ,non_acru_int_recvbl -- 非应计应收利息
    ,wrtn_off_int -- 已核销利息
    ,recvbl_uncol_int -- 应收未收利息
    ,int_paybl -- 应付利息
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_sub_acct_measure_h partition for ('tglsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_sub_acct_measure_h_tglsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_sub_acct_measure_h partition for ('tglsf1') where 0=1;

create table ${iml_schema}.agt_loan_sub_acct_measure_h_tglsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_sub_acct_measure_h partition for ('tglsf1') where 0=1;

-- 3.1 get new data into table
-- tgls_ama_loan_acct-1
insert into ${iml_schema}.agt_loan_sub_acct_measure_h_tglsf1_tm(
    agt_id -- 协议编号
    ,sob_id -- 账套编号
    ,src_sys_cd -- 源系统代码
    ,core_loan_num -- 核心贷款号
    ,tran_flow_num -- 交易流水号
    ,sub_tran_cate_cd -- 子交易类别代码
    ,curr_cd -- 币种代码
    ,org_id -- 机构编号
    ,dubil_id -- 借据编号
    ,bus_type_cd -- 业务类型代码
    ,prod_id -- 产品编号
    ,cont_id -- 合同编号
    ,init_loan_num -- 原贷款号
    ,loan_impam_resv_lmt -- 贷款减值准备金额
    ,discnt_int -- 贴现利息
    ,int_income -- 利息收入
    ,nomal_pric -- 正常本金
    ,other_acct_recvbl_impam_resv_lmt -- 其他应收款减值准备金额
    ,output_tax_lmt -- 销项税额
    ,adv_vat_amt -- 代垫增值税金额
    ,wrtn_off_pric -- 已核销本金
    ,wrtn_off_advc_money -- 已核销垫付款
    ,int_recvbl -- 应收利息
    ,acru_aldy_impam_int -- 应计已减值利息
    ,log_pric -- 保函本金
    ,non_acru_int_recvbl -- 非应计应收利息
    ,wrtn_off_int -- 已核销利息
    ,recvbl_uncol_int -- 应收未收利息
    ,int_paybl -- 应付利息
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300001'||P1.LOANNO -- 协议编号
    ,P1.STACID -- 账套编号
    ,P1.SYSTID -- 源系统代码
    ,P1.LOANNO -- 核心贷款号
    ,P1.TRANSQ -- 交易流水号
    ,nvl(trim(P1.TRANCD),'-'） -- 子交易类别代码
    ,P1.CRCYCD -- 币种代码
    ,P1.DEPTCD -- 机构编号
    ,P1.DEBTNO -- 借据编号
    ,nvl(trim(P1.BUSITP),'-'） -- 业务类型代码
    ,P1.PRDUCD -- 产品编号
    ,P1.LNCTNO -- 合同编号
    ,P1.ODLNNO -- 原贷款号
    ,P1.DEVAAM -- 贷款减值准备金额
    ,P1.INTEAD -- 贴现利息
    ,P1.INTEIN -- 利息收入
    ,P1.NORMPR -- 正常本金
    ,P1.ACIMII -- 其他应收款减值准备金额
    ,P1.VATAXM -- 销项税额
    ,P1.OPPOTR -- 代垫增值税金额
    ,P1.ACCUTO -- 已核销本金
    ,P1.ACASIL -- 已核销垫付款
    ,P1.REINRE -- 应收利息
    ,P1.REGCIR -- 应计已减值利息
    ,P1.REACIN -- 保函本金
    ,P1.REACCI -- 非应计应收利息
    ,P1.REGACI -- 已核销利息
    ,P1.REGICR -- 应收未收利息
    ,P1.COLLPE -- 应付利息
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'tgls_ama_loan_acct' -- 源表名称
    ,'tglsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.tgls_ama_loan_acct p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_sub_acct_measure_h_tglsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,sob_id
  	                                        ,src_sys_cd
  	                                        ,core_loan_num
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
        into ${iml_schema}.agt_loan_sub_acct_measure_h_tglsf1_cl(
            agt_id -- 协议编号
    ,sob_id -- 账套编号
    ,src_sys_cd -- 源系统代码
    ,core_loan_num -- 核心贷款号
    ,tran_flow_num -- 交易流水号
    ,sub_tran_cate_cd -- 子交易类别代码
    ,curr_cd -- 币种代码
    ,org_id -- 机构编号
    ,dubil_id -- 借据编号
    ,bus_type_cd -- 业务类型代码
    ,prod_id -- 产品编号
    ,cont_id -- 合同编号
    ,init_loan_num -- 原贷款号
    ,loan_impam_resv_lmt -- 贷款减值准备金额
    ,discnt_int -- 贴现利息
    ,int_income -- 利息收入
    ,nomal_pric -- 正常本金
    ,other_acct_recvbl_impam_resv_lmt -- 其他应收款减值准备金额
    ,output_tax_lmt -- 销项税额
    ,adv_vat_amt -- 代垫增值税金额
    ,wrtn_off_pric -- 已核销本金
    ,wrtn_off_advc_money -- 已核销垫付款
    ,int_recvbl -- 应收利息
    ,acru_aldy_impam_int -- 应计已减值利息
    ,log_pric -- 保函本金
    ,non_acru_int_recvbl -- 非应计应收利息
    ,wrtn_off_int -- 已核销利息
    ,recvbl_uncol_int -- 应收未收利息
    ,int_paybl -- 应付利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_sub_acct_measure_h_tglsf1_op(
            agt_id -- 协议编号
    ,sob_id -- 账套编号
    ,src_sys_cd -- 源系统代码
    ,core_loan_num -- 核心贷款号
    ,tran_flow_num -- 交易流水号
    ,sub_tran_cate_cd -- 子交易类别代码
    ,curr_cd -- 币种代码
    ,org_id -- 机构编号
    ,dubil_id -- 借据编号
    ,bus_type_cd -- 业务类型代码
    ,prod_id -- 产品编号
    ,cont_id -- 合同编号
    ,init_loan_num -- 原贷款号
    ,loan_impam_resv_lmt -- 贷款减值准备金额
    ,discnt_int -- 贴现利息
    ,int_income -- 利息收入
    ,nomal_pric -- 正常本金
    ,other_acct_recvbl_impam_resv_lmt -- 其他应收款减值准备金额
    ,output_tax_lmt -- 销项税额
    ,adv_vat_amt -- 代垫增值税金额
    ,wrtn_off_pric -- 已核销本金
    ,wrtn_off_advc_money -- 已核销垫付款
    ,int_recvbl -- 应收利息
    ,acru_aldy_impam_int -- 应计已减值利息
    ,log_pric -- 保函本金
    ,non_acru_int_recvbl -- 非应计应收利息
    ,wrtn_off_int -- 已核销利息
    ,recvbl_uncol_int -- 应收未收利息
    ,int_paybl -- 应付利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.sob_id, o.sob_id) as sob_id -- 账套编号
    ,nvl(n.src_sys_cd, o.src_sys_cd) as src_sys_cd -- 源系统代码
    ,nvl(n.core_loan_num, o.core_loan_num) as core_loan_num -- 核心贷款号
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.sub_tran_cate_cd, o.sub_tran_cate_cd) as sub_tran_cate_cd -- 子交易类别代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.bus_type_cd, o.bus_type_cd) as bus_type_cd -- 业务类型代码
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.init_loan_num, o.init_loan_num) as init_loan_num -- 原贷款号
    ,nvl(n.loan_impam_resv_lmt, o.loan_impam_resv_lmt) as loan_impam_resv_lmt -- 贷款减值准备金额
    ,nvl(n.discnt_int, o.discnt_int) as discnt_int -- 贴现利息
    ,nvl(n.int_income, o.int_income) as int_income -- 利息收入
    ,nvl(n.nomal_pric, o.nomal_pric) as nomal_pric -- 正常本金
    ,nvl(n.other_acct_recvbl_impam_resv_lmt, o.other_acct_recvbl_impam_resv_lmt) as other_acct_recvbl_impam_resv_lmt -- 其他应收款减值准备金额
    ,nvl(n.output_tax_lmt, o.output_tax_lmt) as output_tax_lmt -- 销项税额
    ,nvl(n.adv_vat_amt, o.adv_vat_amt) as adv_vat_amt -- 代垫增值税金额
    ,nvl(n.wrtn_off_pric, o.wrtn_off_pric) as wrtn_off_pric -- 已核销本金
    ,nvl(n.wrtn_off_advc_money, o.wrtn_off_advc_money) as wrtn_off_advc_money -- 已核销垫付款
    ,nvl(n.int_recvbl, o.int_recvbl) as int_recvbl -- 应收利息
    ,nvl(n.acru_aldy_impam_int, o.acru_aldy_impam_int) as acru_aldy_impam_int -- 应计已减值利息
    ,nvl(n.log_pric, o.log_pric) as log_pric -- 保函本金
    ,nvl(n.non_acru_int_recvbl, o.non_acru_int_recvbl) as non_acru_int_recvbl -- 非应计应收利息
    ,nvl(n.wrtn_off_int, o.wrtn_off_int) as wrtn_off_int -- 已核销利息
    ,nvl(n.recvbl_uncol_int, o.recvbl_uncol_int) as recvbl_uncol_int -- 应收未收利息
    ,nvl(n.int_paybl, o.int_paybl) as int_paybl -- 应付利息
    ,case when
            n.agt_id is null
            and n.sob_id is null
            and n.src_sys_cd is null
            and n.core_loan_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.sob_id is null
            and n.src_sys_cd is null
            and n.core_loan_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.sob_id is null
            and n.src_sys_cd is null
            and n.core_loan_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_sub_acct_measure_h_tglsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_sub_acct_measure_h_tglsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.sob_id = n.sob_id
            and o.src_sys_cd = n.src_sys_cd
            and o.core_loan_num = n.core_loan_num
where (
        o.agt_id is null
        and o.sob_id is null
        and o.src_sys_cd is null
        and o.core_loan_num is null
    )
    or (
        n.agt_id is null
        and n.sob_id is null
        and n.src_sys_cd is null
        and n.core_loan_num is null
    )
    or (
        o.tran_flow_num <> n.tran_flow_num
        or o.sub_tran_cate_cd <> n.sub_tran_cate_cd
        or o.curr_cd <> n.curr_cd
        or o.org_id <> n.org_id
        or o.dubil_id <> n.dubil_id
        or o.bus_type_cd <> n.bus_type_cd
        or o.prod_id <> n.prod_id
        or o.cont_id <> n.cont_id
        or o.init_loan_num <> n.init_loan_num
        or o.loan_impam_resv_lmt <> n.loan_impam_resv_lmt
        or o.discnt_int <> n.discnt_int
        or o.int_income <> n.int_income
        or o.nomal_pric <> n.nomal_pric
        or o.other_acct_recvbl_impam_resv_lmt <> n.other_acct_recvbl_impam_resv_lmt
        or o.output_tax_lmt <> n.output_tax_lmt
        or o.adv_vat_amt <> n.adv_vat_amt
        or o.wrtn_off_pric <> n.wrtn_off_pric
        or o.wrtn_off_advc_money <> n.wrtn_off_advc_money
        or o.int_recvbl <> n.int_recvbl
        or o.acru_aldy_impam_int <> n.acru_aldy_impam_int
        or o.log_pric <> n.log_pric
        or o.non_acru_int_recvbl <> n.non_acru_int_recvbl
        or o.wrtn_off_int <> n.wrtn_off_int
        or o.recvbl_uncol_int <> n.recvbl_uncol_int
        or o.int_paybl <> n.int_paybl
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_sub_acct_measure_h_tglsf1_cl(
            agt_id -- 协议编号
    ,sob_id -- 账套编号
    ,src_sys_cd -- 源系统代码
    ,core_loan_num -- 核心贷款号
    ,tran_flow_num -- 交易流水号
    ,sub_tran_cate_cd -- 子交易类别代码
    ,curr_cd -- 币种代码
    ,org_id -- 机构编号
    ,dubil_id -- 借据编号
    ,bus_type_cd -- 业务类型代码
    ,prod_id -- 产品编号
    ,cont_id -- 合同编号
    ,init_loan_num -- 原贷款号
    ,loan_impam_resv_lmt -- 贷款减值准备金额
    ,discnt_int -- 贴现利息
    ,int_income -- 利息收入
    ,nomal_pric -- 正常本金
    ,other_acct_recvbl_impam_resv_lmt -- 其他应收款减值准备金额
    ,output_tax_lmt -- 销项税额
    ,adv_vat_amt -- 代垫增值税金额
    ,wrtn_off_pric -- 已核销本金
    ,wrtn_off_advc_money -- 已核销垫付款
    ,int_recvbl -- 应收利息
    ,acru_aldy_impam_int -- 应计已减值利息
    ,log_pric -- 保函本金
    ,non_acru_int_recvbl -- 非应计应收利息
    ,wrtn_off_int -- 已核销利息
    ,recvbl_uncol_int -- 应收未收利息
    ,int_paybl -- 应付利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_sub_acct_measure_h_tglsf1_op(
            agt_id -- 协议编号
    ,sob_id -- 账套编号
    ,src_sys_cd -- 源系统代码
    ,core_loan_num -- 核心贷款号
    ,tran_flow_num -- 交易流水号
    ,sub_tran_cate_cd -- 子交易类别代码
    ,curr_cd -- 币种代码
    ,org_id -- 机构编号
    ,dubil_id -- 借据编号
    ,bus_type_cd -- 业务类型代码
    ,prod_id -- 产品编号
    ,cont_id -- 合同编号
    ,init_loan_num -- 原贷款号
    ,loan_impam_resv_lmt -- 贷款减值准备金额
    ,discnt_int -- 贴现利息
    ,int_income -- 利息收入
    ,nomal_pric -- 正常本金
    ,other_acct_recvbl_impam_resv_lmt -- 其他应收款减值准备金额
    ,output_tax_lmt -- 销项税额
    ,adv_vat_amt -- 代垫增值税金额
    ,wrtn_off_pric -- 已核销本金
    ,wrtn_off_advc_money -- 已核销垫付款
    ,int_recvbl -- 应收利息
    ,acru_aldy_impam_int -- 应计已减值利息
    ,log_pric -- 保函本金
    ,non_acru_int_recvbl -- 非应计应收利息
    ,wrtn_off_int -- 已核销利息
    ,recvbl_uncol_int -- 应收未收利息
    ,int_paybl -- 应付利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.sob_id -- 账套编号
    ,o.src_sys_cd -- 源系统代码
    ,o.core_loan_num -- 核心贷款号
    ,o.tran_flow_num -- 交易流水号
    ,o.sub_tran_cate_cd -- 子交易类别代码
    ,o.curr_cd -- 币种代码
    ,o.org_id -- 机构编号
    ,o.dubil_id -- 借据编号
    ,o.bus_type_cd -- 业务类型代码
    ,o.prod_id -- 产品编号
    ,o.cont_id -- 合同编号
    ,o.init_loan_num -- 原贷款号
    ,o.loan_impam_resv_lmt -- 贷款减值准备金额
    ,o.discnt_int -- 贴现利息
    ,o.int_income -- 利息收入
    ,o.nomal_pric -- 正常本金
    ,o.other_acct_recvbl_impam_resv_lmt -- 其他应收款减值准备金额
    ,o.output_tax_lmt -- 销项税额
    ,o.adv_vat_amt -- 代垫增值税金额
    ,o.wrtn_off_pric -- 已核销本金
    ,o.wrtn_off_advc_money -- 已核销垫付款
    ,o.int_recvbl -- 应收利息
    ,o.acru_aldy_impam_int -- 应计已减值利息
    ,o.log_pric -- 保函本金
    ,o.non_acru_int_recvbl -- 非应计应收利息
    ,o.wrtn_off_int -- 已核销利息
    ,o.recvbl_uncol_int -- 应收未收利息
    ,o.int_paybl -- 应付利息
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
from ${iml_schema}.agt_loan_sub_acct_measure_h_tglsf1_bk o
    left join ${iml_schema}.agt_loan_sub_acct_measure_h_tglsf1_op n
        on
            o.agt_id = n.agt_id
            and o.sob_id = n.sob_id
            and o.src_sys_cd = n.src_sys_cd
            and o.core_loan_num = n.core_loan_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_sub_acct_measure_h_tglsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.sob_id = d.sob_id
            and o.src_sys_cd = d.src_sys_cd
            and o.core_loan_num = d.core_loan_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_sub_acct_measure_h;
--alter table ${iml_schema}.agt_loan_sub_acct_measure_h truncate partition for ('tglsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_sub_acct_measure_h') 
               and substr(subpartition_name,1,8)=upper('p_tglsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_sub_acct_measure_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_loan_sub_acct_measure_h modify partition p_tglsf1 
add subpartition p_tglsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_sub_acct_measure_h exchange subpartition p_tglsf1_${batch_date} with table ${iml_schema}.agt_loan_sub_acct_measure_h_tglsf1_cl;
alter table ${iml_schema}.agt_loan_sub_acct_measure_h exchange subpartition p_tglsf1_20991231 with table ${iml_schema}.agt_loan_sub_acct_measure_h_tglsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_sub_acct_measure_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_sub_acct_measure_h_tglsf1_tm purge;
drop table ${iml_schema}.agt_loan_sub_acct_measure_h_tglsf1_op purge;
drop table ${iml_schema}.agt_loan_sub_acct_measure_h_tglsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_sub_acct_measure_h_tglsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_sub_acct_measure_h', partname => 'p_tglsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
