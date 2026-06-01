/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_long_hang_acct_oper_info_h_ncbsf1
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
alter table ${iml_schema}.agt_long_hang_acct_oper_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_long_hang_acct_oper_info_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_long_hang_acct_oper_info_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_long_hang_acct_oper_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_long_hang_acct_oper_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_long_hang_acct_oper_info_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_long_hang_acct_oper_info_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,bus_batch_no -- 业务批次号
    ,turn_long_hang_oper_type_cd -- 转久悬操作类型代码
    ,manual_imp_flg -- 手工导入标志
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,amt_type_cd -- 金额类型代码
    ,bal -- 余额
    ,int_amt -- 利息金额
    ,acct_pric_int_sum -- 账户本息合计
    ,acct_int_tax -- 账户利息税
    ,prep_turn_long_hang_org_id -- 待转久悬机构编号
    ,prep_turn_long_hang_oper_teller_id -- 待转久悬操作柜员编号
    ,prep_turn_long_hang_dt -- 待转久悬日期
    ,prep_turn_out_bus_dt -- 待转营业外日期
    ,prep_turn_out_bus_oper_teller_id -- 待转营业外操作柜员编号
    ,long_hang_clean_dt -- 久悬清理日期
    ,long_hang_clean_org_id -- 久悬清理机构编号
    ,tran_out_teller_id -- 转出柜员编号
    ,tran_out_long_hang_rs -- 转出久悬原因
    ,long_hang_status_cd -- 久悬状态代码
    ,turn_long_hang_dt -- 转久悬日期
    ,turn_long_hang_org_id -- 转久悬机构编号
    ,turn_long_hang_teller_id -- 转久悬柜员编号
    ,tran_in_long_hang_rs -- 转入久悬原因
    ,acct_actv_dt -- 账户激活日期
    ,actv_org_id -- 激活机构编号
    ,actv_teller_id -- 激活柜员编号
    ,turn_out_bus_dt -- 转营业外日期
    ,turn_out_bus_oper_teller_id -- 转营业外操作柜员编号
    ,priv_flg -- 对私标志
    ,tran_out_acct_num_obank_flg -- 转出账号他行标志
    ,tran_out_acct_id -- 转出账户编号
    ,aim_curr_cd -- 目的币种代码
    ,tran_out_acct_sub_acct_num -- 转出账户子账号
    ,tran_out_acct_name -- 转出账户名称
    ,tran_in_acct_type_cd -- 转入账户类型代码
    ,addit_remark -- 附加备注
    ,tran_tm -- 交易时间
    ,actl_enter_acct_amt -- 实际入账金额
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_amt -- 交易金额
    ,tran_ref_no -- 交易参考号
    ,auth_teller_id -- 授权柜员编号
    ,chn_id -- 渠道编号
    ,edit_id -- 版本编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_long_hang_acct_oper_info_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_long_hang_acct_oper_info_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_long_hang_acct_oper_info_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_long_hang_acct_oper_info_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_long_hang_acct_oper_info_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_acct_doss_reg-1
insert into ${iml_schema}.agt_long_hang_acct_oper_info_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,bus_batch_no -- 业务批次号
    ,turn_long_hang_oper_type_cd -- 转久悬操作类型代码
    ,manual_imp_flg -- 手工导入标志
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,amt_type_cd -- 金额类型代码
    ,bal -- 余额
    ,int_amt -- 利息金额
    ,acct_pric_int_sum -- 账户本息合计
    ,acct_int_tax -- 账户利息税
    ,prep_turn_long_hang_org_id -- 待转久悬机构编号
    ,prep_turn_long_hang_oper_teller_id -- 待转久悬操作柜员编号
    ,prep_turn_long_hang_dt -- 待转久悬日期
    ,prep_turn_out_bus_dt -- 待转营业外日期
    ,prep_turn_out_bus_oper_teller_id -- 待转营业外操作柜员编号
    ,long_hang_clean_dt -- 久悬清理日期
    ,long_hang_clean_org_id -- 久悬清理机构编号
    ,tran_out_teller_id -- 转出柜员编号
    ,tran_out_long_hang_rs -- 转出久悬原因
    ,long_hang_status_cd -- 久悬状态代码
    ,turn_long_hang_dt -- 转久悬日期
    ,turn_long_hang_org_id -- 转久悬机构编号
    ,turn_long_hang_teller_id -- 转久悬柜员编号
    ,tran_in_long_hang_rs -- 转入久悬原因
    ,acct_actv_dt -- 账户激活日期
    ,actv_org_id -- 激活机构编号
    ,actv_teller_id -- 激活柜员编号
    ,turn_out_bus_dt -- 转营业外日期
    ,turn_out_bus_oper_teller_id -- 转营业外操作柜员编号
    ,priv_flg -- 对私标志
    ,tran_out_acct_num_obank_flg -- 转出账号他行标志
    ,tran_out_acct_id -- 转出账户编号
    ,aim_curr_cd -- 目的币种代码
    ,tran_out_acct_sub_acct_num -- 转出账户子账号
    ,tran_out_acct_name -- 转出账户名称
    ,tran_in_acct_type_cd -- 转入账户类型代码
    ,addit_remark -- 附加备注
    ,tran_tm -- 交易时间
    ,actl_enter_acct_amt -- 实际入账金额
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_amt -- 交易金额
    ,tran_ref_no -- 交易参考号
    ,auth_teller_id -- 授权柜员编号
    ,chn_id -- 渠道编号
    ,edit_id -- 版本编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '120010'||P1.INTERNAL_KEY -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.BATCH_NO -- 业务批次号
    ,P1.DOSS_OPERATE_TYPE -- 转久悬操作类型代码
    ,decode(trim(p1.HAND_FLAG),'','-','Y','1','N','0',p1.HAND_FLAG) -- 手工导入标志
    ,P1.CLIENT_NO -- 客户编号
    ,nvl(trim(p8.card_no),p1.BASE_ACCT_NO) -- 客户账号
    ,P1.PROD_TYPE -- 产品编号
    ,nvl(trim(P1.ACCT_CCY),'-') -- 币种代码
    ,P1.ACCT_SEQ_NO -- 子账号
    ,P1.ACCT_NAME -- 账户名称
    ,nvl(trim(P1.AMT_TYPE),'-') -- 金额类型代码
    ,P1.BALANCE -- 余额
    ,P1.INT_AMT -- 利息金额
    ,P1.POR_INT_TOT -- 账户本息合计
    ,P1.TAX_SC -- 账户利息税
    ,P1.WAITDOSS_BRANCH -- 待转久悬机构编号
    ,P1.WAITDOSS_USER_ID -- 待转久悬操作柜员编号
    ,P1.WAITDOSS_DATE -- 待转久悬日期
    ,P1.WAITOUT_DATE -- 待转营业外日期
    ,P1.WAITOUT_USER_ID -- 待转营业外操作柜员编号
    ,P1.WITHDRAWAL_DATE -- 久悬清理日期
    ,P1.WITHDRAWAL_BRANCH -- 久悬清理机构编号
    ,P1.WITHDRAWAL_USER_ID -- 转出柜员编号
    ,P1.WITHDRAWAL_REASON -- 转出久悬原因
    ,P1.DOSS_STATUS -- 久悬状态代码
    ,P1.DOSS_DATE -- 转久悬日期
    ,P1.DOSS_BRANCH -- 转久悬机构编号
    ,P1.DOSS_USER_ID -- 转久悬柜员编号
    ,P1.TODOSS_REASON -- 转入久悬原因
    ,P1.ACTIVE_DATE -- 账户激活日期
    ,P1.ACTIVE_BRANCH -- 激活机构编号
    ,P1.ACTIVE_USER_ID -- 激活柜员编号
    ,P1.OUT_BUSI_DATE -- 转营业外日期
    ,P1.OUT_BUSI_USER_ID -- 转营业外操作柜员编号
    ,DECODE(P1.INDIVIDUAL_FLAG,'Y','1','N','0') -- 对私标志
    ,nvl(trim(P1.TO_BANK_IND),'-') -- 转出账号他行标志
    ,nvl(trim(p9.card_no),p1.TO_BASE_ACCT_NO) -- 转出账户编号
    ,nvl(trim(P1.TO_CCY),'-') -- 目的币种代码
    ,P1.TO_ACCT_SEQ_NO -- 转出账户子账号
    ,P1.TO_ACCT_NAME -- 转出账户名称
    ,nvl(trim(P1.TO_ACCT_TYPE),'-') -- 转入账户类型代码
    ,P1.REMARK -- 附加备注
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.RECORD_AMT -- 实际入账金额
    ,P1.TRAN_DATE -- 交易日期
    ,P1.BRANCH -- 交易机构编号
    ,P1.USER_ID -- 交易柜员编号
    ,P1.TRAN_AMT -- 交易金额
    ,P1.REFERENCE -- 交易参考号
    ,P1.AUTH_USER_ID -- 授权柜员编号
    ,P1.SOURCE_TYPE -- 渠道编号
    ,P1.BOND_VERSION_NUM -- 版本编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_acct_doss_reg' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_acct_doss_reg p1
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p8 on p1.BASE_ACCT_NO=p8.BASE_ACCT_NO and p8.BASE_ACCT_NO LIKE '0%'
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p9 on p1.TO_BASE_ACCT_NO=p9.BASE_ACCT_NO and p9.BASE_ACCT_NO LIKE '0%'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_long_hang_acct_oper_info_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
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
        into ${iml_schema}.agt_long_hang_acct_oper_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,bus_batch_no -- 业务批次号
    ,turn_long_hang_oper_type_cd -- 转久悬操作类型代码
    ,manual_imp_flg -- 手工导入标志
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,amt_type_cd -- 金额类型代码
    ,bal -- 余额
    ,int_amt -- 利息金额
    ,acct_pric_int_sum -- 账户本息合计
    ,acct_int_tax -- 账户利息税
    ,prep_turn_long_hang_org_id -- 待转久悬机构编号
    ,prep_turn_long_hang_oper_teller_id -- 待转久悬操作柜员编号
    ,prep_turn_long_hang_dt -- 待转久悬日期
    ,prep_turn_out_bus_dt -- 待转营业外日期
    ,prep_turn_out_bus_oper_teller_id -- 待转营业外操作柜员编号
    ,long_hang_clean_dt -- 久悬清理日期
    ,long_hang_clean_org_id -- 久悬清理机构编号
    ,tran_out_teller_id -- 转出柜员编号
    ,tran_out_long_hang_rs -- 转出久悬原因
    ,long_hang_status_cd -- 久悬状态代码
    ,turn_long_hang_dt -- 转久悬日期
    ,turn_long_hang_org_id -- 转久悬机构编号
    ,turn_long_hang_teller_id -- 转久悬柜员编号
    ,tran_in_long_hang_rs -- 转入久悬原因
    ,acct_actv_dt -- 账户激活日期
    ,actv_org_id -- 激活机构编号
    ,actv_teller_id -- 激活柜员编号
    ,turn_out_bus_dt -- 转营业外日期
    ,turn_out_bus_oper_teller_id -- 转营业外操作柜员编号
    ,priv_flg -- 对私标志
    ,tran_out_acct_num_obank_flg -- 转出账号他行标志
    ,tran_out_acct_id -- 转出账户编号
    ,aim_curr_cd -- 目的币种代码
    ,tran_out_acct_sub_acct_num -- 转出账户子账号
    ,tran_out_acct_name -- 转出账户名称
    ,tran_in_acct_type_cd -- 转入账户类型代码
    ,addit_remark -- 附加备注
    ,tran_tm -- 交易时间
    ,actl_enter_acct_amt -- 实际入账金额
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_amt -- 交易金额
    ,tran_ref_no -- 交易参考号
    ,auth_teller_id -- 授权柜员编号
    ,chn_id -- 渠道编号
    ,edit_id -- 版本编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_long_hang_acct_oper_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,bus_batch_no -- 业务批次号
    ,turn_long_hang_oper_type_cd -- 转久悬操作类型代码
    ,manual_imp_flg -- 手工导入标志
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,amt_type_cd -- 金额类型代码
    ,bal -- 余额
    ,int_amt -- 利息金额
    ,acct_pric_int_sum -- 账户本息合计
    ,acct_int_tax -- 账户利息税
    ,prep_turn_long_hang_org_id -- 待转久悬机构编号
    ,prep_turn_long_hang_oper_teller_id -- 待转久悬操作柜员编号
    ,prep_turn_long_hang_dt -- 待转久悬日期
    ,prep_turn_out_bus_dt -- 待转营业外日期
    ,prep_turn_out_bus_oper_teller_id -- 待转营业外操作柜员编号
    ,long_hang_clean_dt -- 久悬清理日期
    ,long_hang_clean_org_id -- 久悬清理机构编号
    ,tran_out_teller_id -- 转出柜员编号
    ,tran_out_long_hang_rs -- 转出久悬原因
    ,long_hang_status_cd -- 久悬状态代码
    ,turn_long_hang_dt -- 转久悬日期
    ,turn_long_hang_org_id -- 转久悬机构编号
    ,turn_long_hang_teller_id -- 转久悬柜员编号
    ,tran_in_long_hang_rs -- 转入久悬原因
    ,acct_actv_dt -- 账户激活日期
    ,actv_org_id -- 激活机构编号
    ,actv_teller_id -- 激活柜员编号
    ,turn_out_bus_dt -- 转营业外日期
    ,turn_out_bus_oper_teller_id -- 转营业外操作柜员编号
    ,priv_flg -- 对私标志
    ,tran_out_acct_num_obank_flg -- 转出账号他行标志
    ,tran_out_acct_id -- 转出账户编号
    ,aim_curr_cd -- 目的币种代码
    ,tran_out_acct_sub_acct_num -- 转出账户子账号
    ,tran_out_acct_name -- 转出账户名称
    ,tran_in_acct_type_cd -- 转入账户类型代码
    ,addit_remark -- 附加备注
    ,tran_tm -- 交易时间
    ,actl_enter_acct_amt -- 实际入账金额
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_amt -- 交易金额
    ,tran_ref_no -- 交易参考号
    ,auth_teller_id -- 授权柜员编号
    ,chn_id -- 渠道编号
    ,edit_id -- 版本编号
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
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.bus_batch_no, o.bus_batch_no) as bus_batch_no -- 业务批次号
    ,nvl(n.turn_long_hang_oper_type_cd, o.turn_long_hang_oper_type_cd) as turn_long_hang_oper_type_cd -- 转久悬操作类型代码
    ,nvl(n.manual_imp_flg, o.manual_imp_flg) as manual_imp_flg -- 手工导入标志
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.sub_acct_num, o.sub_acct_num) as sub_acct_num -- 子账号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.amt_type_cd, o.amt_type_cd) as amt_type_cd -- 金额类型代码
    ,nvl(n.bal, o.bal) as bal -- 余额
    ,nvl(n.int_amt, o.int_amt) as int_amt -- 利息金额
    ,nvl(n.acct_pric_int_sum, o.acct_pric_int_sum) as acct_pric_int_sum -- 账户本息合计
    ,nvl(n.acct_int_tax, o.acct_int_tax) as acct_int_tax -- 账户利息税
    ,nvl(n.prep_turn_long_hang_org_id, o.prep_turn_long_hang_org_id) as prep_turn_long_hang_org_id -- 待转久悬机构编号
    ,nvl(n.prep_turn_long_hang_oper_teller_id, o.prep_turn_long_hang_oper_teller_id) as prep_turn_long_hang_oper_teller_id -- 待转久悬操作柜员编号
    ,nvl(n.prep_turn_long_hang_dt, o.prep_turn_long_hang_dt) as prep_turn_long_hang_dt -- 待转久悬日期
    ,nvl(n.prep_turn_out_bus_dt, o.prep_turn_out_bus_dt) as prep_turn_out_bus_dt -- 待转营业外日期
    ,nvl(n.prep_turn_out_bus_oper_teller_id, o.prep_turn_out_bus_oper_teller_id) as prep_turn_out_bus_oper_teller_id -- 待转营业外操作柜员编号
    ,nvl(n.long_hang_clean_dt, o.long_hang_clean_dt) as long_hang_clean_dt -- 久悬清理日期
    ,nvl(n.long_hang_clean_org_id, o.long_hang_clean_org_id) as long_hang_clean_org_id -- 久悬清理机构编号
    ,nvl(n.tran_out_teller_id, o.tran_out_teller_id) as tran_out_teller_id -- 转出柜员编号
    ,nvl(n.tran_out_long_hang_rs, o.tran_out_long_hang_rs) as tran_out_long_hang_rs -- 转出久悬原因
    ,nvl(n.long_hang_status_cd, o.long_hang_status_cd) as long_hang_status_cd -- 久悬状态代码
    ,nvl(n.turn_long_hang_dt, o.turn_long_hang_dt) as turn_long_hang_dt -- 转久悬日期
    ,nvl(n.turn_long_hang_org_id, o.turn_long_hang_org_id) as turn_long_hang_org_id -- 转久悬机构编号
    ,nvl(n.turn_long_hang_teller_id, o.turn_long_hang_teller_id) as turn_long_hang_teller_id -- 转久悬柜员编号
    ,nvl(n.tran_in_long_hang_rs, o.tran_in_long_hang_rs) as tran_in_long_hang_rs -- 转入久悬原因
    ,nvl(n.acct_actv_dt, o.acct_actv_dt) as acct_actv_dt -- 账户激活日期
    ,nvl(n.actv_org_id, o.actv_org_id) as actv_org_id -- 激活机构编号
    ,nvl(n.actv_teller_id, o.actv_teller_id) as actv_teller_id -- 激活柜员编号
    ,nvl(n.turn_out_bus_dt, o.turn_out_bus_dt) as turn_out_bus_dt -- 转营业外日期
    ,nvl(n.turn_out_bus_oper_teller_id, o.turn_out_bus_oper_teller_id) as turn_out_bus_oper_teller_id -- 转营业外操作柜员编号
    ,nvl(n.priv_flg, o.priv_flg) as priv_flg -- 对私标志
    ,nvl(n.tran_out_acct_num_obank_flg, o.tran_out_acct_num_obank_flg) as tran_out_acct_num_obank_flg -- 转出账号他行标志
    ,nvl(n.tran_out_acct_id, o.tran_out_acct_id) as tran_out_acct_id -- 转出账户编号
    ,nvl(n.aim_curr_cd, o.aim_curr_cd) as aim_curr_cd -- 目的币种代码
    ,nvl(n.tran_out_acct_sub_acct_num, o.tran_out_acct_sub_acct_num) as tran_out_acct_sub_acct_num -- 转出账户子账号
    ,nvl(n.tran_out_acct_name, o.tran_out_acct_name) as tran_out_acct_name -- 转出账户名称
    ,nvl(n.tran_in_acct_type_cd, o.tran_in_acct_type_cd) as tran_in_acct_type_cd -- 转入账户类型代码
    ,nvl(n.addit_remark, o.addit_remark) as addit_remark -- 附加备注
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.actl_enter_acct_amt, o.actl_enter_acct_amt) as actl_enter_acct_amt -- 实际入账金额
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.tran_ref_no, o.tran_ref_no) as tran_ref_no -- 交易参考号
    ,nvl(n.auth_teller_id, o.auth_teller_id) as auth_teller_id -- 授权柜员编号
    ,nvl(n.chn_id, o.chn_id) as chn_id -- 渠道编号
    ,nvl(n.edit_id, o.edit_id) as edit_id -- 版本编号
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_long_hang_acct_oper_info_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_long_hang_acct_oper_info_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.acct_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.acct_id is null
    )
    or (
        o.bus_batch_no <> n.bus_batch_no
        or o.turn_long_hang_oper_type_cd <> n.turn_long_hang_oper_type_cd
        or o.manual_imp_flg <> n.manual_imp_flg
        or o.cust_id <> n.cust_id
        or o.cust_acct_num <> n.cust_acct_num
        or o.prod_id <> n.prod_id
        or o.curr_cd <> n.curr_cd
        or o.sub_acct_num <> n.sub_acct_num
        or o.acct_name <> n.acct_name
        or o.amt_type_cd <> n.amt_type_cd
        or o.bal <> n.bal
        or o.int_amt <> n.int_amt
        or o.acct_pric_int_sum <> n.acct_pric_int_sum
        or o.acct_int_tax <> n.acct_int_tax
        or o.prep_turn_long_hang_org_id <> n.prep_turn_long_hang_org_id
        or o.prep_turn_long_hang_oper_teller_id <> n.prep_turn_long_hang_oper_teller_id
        or o.prep_turn_long_hang_dt <> n.prep_turn_long_hang_dt
        or o.prep_turn_out_bus_dt <> n.prep_turn_out_bus_dt
        or o.prep_turn_out_bus_oper_teller_id <> n.prep_turn_out_bus_oper_teller_id
        or o.long_hang_clean_dt <> n.long_hang_clean_dt
        or o.long_hang_clean_org_id <> n.long_hang_clean_org_id
        or o.tran_out_teller_id <> n.tran_out_teller_id
        or o.tran_out_long_hang_rs <> n.tran_out_long_hang_rs
        or o.long_hang_status_cd <> n.long_hang_status_cd
        or o.turn_long_hang_dt <> n.turn_long_hang_dt
        or o.turn_long_hang_org_id <> n.turn_long_hang_org_id
        or o.turn_long_hang_teller_id <> n.turn_long_hang_teller_id
        or o.tran_in_long_hang_rs <> n.tran_in_long_hang_rs
        or o.acct_actv_dt <> n.acct_actv_dt
        or o.actv_org_id <> n.actv_org_id
        or o.actv_teller_id <> n.actv_teller_id
        or o.turn_out_bus_dt <> n.turn_out_bus_dt
        or o.turn_out_bus_oper_teller_id <> n.turn_out_bus_oper_teller_id
        or o.priv_flg <> n.priv_flg
        or o.tran_out_acct_num_obank_flg <> n.tran_out_acct_num_obank_flg
        or o.tran_out_acct_id <> n.tran_out_acct_id
        or o.aim_curr_cd <> n.aim_curr_cd
        or o.tran_out_acct_sub_acct_num <> n.tran_out_acct_sub_acct_num
        or o.tran_out_acct_name <> n.tran_out_acct_name
        or o.tran_in_acct_type_cd <> n.tran_in_acct_type_cd
        or o.addit_remark <> n.addit_remark
        or o.tran_tm <> n.tran_tm
        or o.actl_enter_acct_amt <> n.actl_enter_acct_amt
        or o.tran_dt <> n.tran_dt
        or o.tran_org_id <> n.tran_org_id
        or o.tran_teller_id <> n.tran_teller_id
        or o.tran_amt <> n.tran_amt
        or o.tran_ref_no <> n.tran_ref_no
        or o.auth_teller_id <> n.auth_teller_id
        or o.chn_id <> n.chn_id
        or o.edit_id <> n.edit_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_long_hang_acct_oper_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,bus_batch_no -- 业务批次号
    ,turn_long_hang_oper_type_cd -- 转久悬操作类型代码
    ,manual_imp_flg -- 手工导入标志
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,amt_type_cd -- 金额类型代码
    ,bal -- 余额
    ,int_amt -- 利息金额
    ,acct_pric_int_sum -- 账户本息合计
    ,acct_int_tax -- 账户利息税
    ,prep_turn_long_hang_org_id -- 待转久悬机构编号
    ,prep_turn_long_hang_oper_teller_id -- 待转久悬操作柜员编号
    ,prep_turn_long_hang_dt -- 待转久悬日期
    ,prep_turn_out_bus_dt -- 待转营业外日期
    ,prep_turn_out_bus_oper_teller_id -- 待转营业外操作柜员编号
    ,long_hang_clean_dt -- 久悬清理日期
    ,long_hang_clean_org_id -- 久悬清理机构编号
    ,tran_out_teller_id -- 转出柜员编号
    ,tran_out_long_hang_rs -- 转出久悬原因
    ,long_hang_status_cd -- 久悬状态代码
    ,turn_long_hang_dt -- 转久悬日期
    ,turn_long_hang_org_id -- 转久悬机构编号
    ,turn_long_hang_teller_id -- 转久悬柜员编号
    ,tran_in_long_hang_rs -- 转入久悬原因
    ,acct_actv_dt -- 账户激活日期
    ,actv_org_id -- 激活机构编号
    ,actv_teller_id -- 激活柜员编号
    ,turn_out_bus_dt -- 转营业外日期
    ,turn_out_bus_oper_teller_id -- 转营业外操作柜员编号
    ,priv_flg -- 对私标志
    ,tran_out_acct_num_obank_flg -- 转出账号他行标志
    ,tran_out_acct_id -- 转出账户编号
    ,aim_curr_cd -- 目的币种代码
    ,tran_out_acct_sub_acct_num -- 转出账户子账号
    ,tran_out_acct_name -- 转出账户名称
    ,tran_in_acct_type_cd -- 转入账户类型代码
    ,addit_remark -- 附加备注
    ,tran_tm -- 交易时间
    ,actl_enter_acct_amt -- 实际入账金额
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_amt -- 交易金额
    ,tran_ref_no -- 交易参考号
    ,auth_teller_id -- 授权柜员编号
    ,chn_id -- 渠道编号
    ,edit_id -- 版本编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_long_hang_acct_oper_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,bus_batch_no -- 业务批次号
    ,turn_long_hang_oper_type_cd -- 转久悬操作类型代码
    ,manual_imp_flg -- 手工导入标志
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,amt_type_cd -- 金额类型代码
    ,bal -- 余额
    ,int_amt -- 利息金额
    ,acct_pric_int_sum -- 账户本息合计
    ,acct_int_tax -- 账户利息税
    ,prep_turn_long_hang_org_id -- 待转久悬机构编号
    ,prep_turn_long_hang_oper_teller_id -- 待转久悬操作柜员编号
    ,prep_turn_long_hang_dt -- 待转久悬日期
    ,prep_turn_out_bus_dt -- 待转营业外日期
    ,prep_turn_out_bus_oper_teller_id -- 待转营业外操作柜员编号
    ,long_hang_clean_dt -- 久悬清理日期
    ,long_hang_clean_org_id -- 久悬清理机构编号
    ,tran_out_teller_id -- 转出柜员编号
    ,tran_out_long_hang_rs -- 转出久悬原因
    ,long_hang_status_cd -- 久悬状态代码
    ,turn_long_hang_dt -- 转久悬日期
    ,turn_long_hang_org_id -- 转久悬机构编号
    ,turn_long_hang_teller_id -- 转久悬柜员编号
    ,tran_in_long_hang_rs -- 转入久悬原因
    ,acct_actv_dt -- 账户激活日期
    ,actv_org_id -- 激活机构编号
    ,actv_teller_id -- 激活柜员编号
    ,turn_out_bus_dt -- 转营业外日期
    ,turn_out_bus_oper_teller_id -- 转营业外操作柜员编号
    ,priv_flg -- 对私标志
    ,tran_out_acct_num_obank_flg -- 转出账号他行标志
    ,tran_out_acct_id -- 转出账户编号
    ,aim_curr_cd -- 目的币种代码
    ,tran_out_acct_sub_acct_num -- 转出账户子账号
    ,tran_out_acct_name -- 转出账户名称
    ,tran_in_acct_type_cd -- 转入账户类型代码
    ,addit_remark -- 附加备注
    ,tran_tm -- 交易时间
    ,actl_enter_acct_amt -- 实际入账金额
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_amt -- 交易金额
    ,tran_ref_no -- 交易参考号
    ,auth_teller_id -- 授权柜员编号
    ,chn_id -- 渠道编号
    ,edit_id -- 版本编号
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
    ,o.acct_id -- 账户编号
    ,o.bus_batch_no -- 业务批次号
    ,o.turn_long_hang_oper_type_cd -- 转久悬操作类型代码
    ,o.manual_imp_flg -- 手工导入标志
    ,o.cust_id -- 客户编号
    ,o.cust_acct_num -- 客户账号
    ,o.prod_id -- 产品编号
    ,o.curr_cd -- 币种代码
    ,o.sub_acct_num -- 子账号
    ,o.acct_name -- 账户名称
    ,o.amt_type_cd -- 金额类型代码
    ,o.bal -- 余额
    ,o.int_amt -- 利息金额
    ,o.acct_pric_int_sum -- 账户本息合计
    ,o.acct_int_tax -- 账户利息税
    ,o.prep_turn_long_hang_org_id -- 待转久悬机构编号
    ,o.prep_turn_long_hang_oper_teller_id -- 待转久悬操作柜员编号
    ,o.prep_turn_long_hang_dt -- 待转久悬日期
    ,o.prep_turn_out_bus_dt -- 待转营业外日期
    ,o.prep_turn_out_bus_oper_teller_id -- 待转营业外操作柜员编号
    ,o.long_hang_clean_dt -- 久悬清理日期
    ,o.long_hang_clean_org_id -- 久悬清理机构编号
    ,o.tran_out_teller_id -- 转出柜员编号
    ,o.tran_out_long_hang_rs -- 转出久悬原因
    ,o.long_hang_status_cd -- 久悬状态代码
    ,o.turn_long_hang_dt -- 转久悬日期
    ,o.turn_long_hang_org_id -- 转久悬机构编号
    ,o.turn_long_hang_teller_id -- 转久悬柜员编号
    ,o.tran_in_long_hang_rs -- 转入久悬原因
    ,o.acct_actv_dt -- 账户激活日期
    ,o.actv_org_id -- 激活机构编号
    ,o.actv_teller_id -- 激活柜员编号
    ,o.turn_out_bus_dt -- 转营业外日期
    ,o.turn_out_bus_oper_teller_id -- 转营业外操作柜员编号
    ,o.priv_flg -- 对私标志
    ,o.tran_out_acct_num_obank_flg -- 转出账号他行标志
    ,o.tran_out_acct_id -- 转出账户编号
    ,o.aim_curr_cd -- 目的币种代码
    ,o.tran_out_acct_sub_acct_num -- 转出账户子账号
    ,o.tran_out_acct_name -- 转出账户名称
    ,o.tran_in_acct_type_cd -- 转入账户类型代码
    ,o.addit_remark -- 附加备注
    ,o.tran_tm -- 交易时间
    ,o.actl_enter_acct_amt -- 实际入账金额
    ,o.tran_dt -- 交易日期
    ,o.tran_org_id -- 交易机构编号
    ,o.tran_teller_id -- 交易柜员编号
    ,o.tran_amt -- 交易金额
    ,o.tran_ref_no -- 交易参考号
    ,o.auth_teller_id -- 授权柜员编号
    ,o.chn_id -- 渠道编号
    ,o.edit_id -- 版本编号
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
from ${iml_schema}.agt_long_hang_acct_oper_info_h_ncbsf1_bk o
    left join ${iml_schema}.agt_long_hang_acct_oper_info_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_long_hang_acct_oper_info_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.acct_id = d.acct_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_long_hang_acct_oper_info_h;
--alter table ${iml_schema}.agt_long_hang_acct_oper_info_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_long_hang_acct_oper_info_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_long_hang_acct_oper_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_long_hang_acct_oper_info_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_long_hang_acct_oper_info_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_long_hang_acct_oper_info_h_ncbsf1_cl;
alter table ${iml_schema}.agt_long_hang_acct_oper_info_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_long_hang_acct_oper_info_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_long_hang_acct_oper_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_long_hang_acct_oper_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_long_hang_acct_oper_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_long_hang_acct_oper_info_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_long_hang_acct_oper_info_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_long_hang_acct_oper_info_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
