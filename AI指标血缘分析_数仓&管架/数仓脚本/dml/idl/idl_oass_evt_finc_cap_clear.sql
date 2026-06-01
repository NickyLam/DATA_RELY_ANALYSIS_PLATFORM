/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_evt_finc_cap_clear
CreateDate: 20221106
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.oass_evt_finc_cap_clear drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_evt_finc_cap_clear add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_evt_finc_cap_clear (
etl_dt  --数据日期
,clear_flow_num  --清算流水号
,clear_seq_num  --清算顺序号
,tran_dt  --交易日期
,clear_dt  --清算日期
,actl_enter_acct_dt  --实际入帐日期
,chg_bf_clear_dt  --变动前清算日期
,flow_num  --流水号
,rela_flow_num  --关联流水号
,intior_cd  --发起方代码
,tran_cd  --交易代码
,bus_cd  --业务代码
,cust_type_cd  --客户类型代码
,intnal_cust_id  --内部客户编号
,bank_id  --银行编号
,cust_id  --交易客户编号
,bank_acct_num  --银行账号
,bank_acct_type_cd  --银行帐户类型代码
,tran_chn_cd  --交易渠道代码
,tran_teller_id  --交易柜员编号
,termn_id  --交易终端编号
,tran_org_id  --交易机构编号
,tran_belong_org_id  --交易所属机构编号
,ta_cd  --TA代码
,prod_id  --产品编号
,acct_dir_cd  --账务方向代码
,clear_amt  --清算金额
,curr_cd  --币种代码
,ec_idf_cd  --钞汇标识代码
,unfrz_amt  --解冻金额
,host_tran_code  --主机交易码
,host_dt  --主机日期
,host_flow_num  --主机流水号
,froz_amt  --冻结金额
,bal_chk_cfm_cd  --勾对确认代码
,acct_amt_src_type_cd  --上帐金额来源类型代码
,cap_cate_cd  --资金类别代码
,pric_prft_cd  --本金收益代码
,cfm_lot  --确认份额
,pric_amt  --本金金额
,cfm_prft_amt  --确认收益金额
,lot_accu_accum  --份额累积积数
,prod_acct_num  --产品账号
,prod_acct_type_cd  --产品账户类型代码
,memo_comnt  --摘要说明
,cap_clear_status_cd  --资金清算状态代码
,init_clear_flow_num  --原清算流水号
,return_code  --返回码
,err_info_desc  --错误信息描述
,intfc_proc_flg  --接口处理标志
,remark_info_1  --备注信息1
,remark_info_2  --备注信息2
,remark_info_3  --备注信息3
,remark_info_4  --备注信息4
,remark_info_5  --备注信息5
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,evt_id  --事件编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.clear_flow_num,chr(13),''),chr(10),'') as clear_flow_num --清算流水号
,replace(replace(t1.clear_seq_num,chr(13),''),chr(10),'') as clear_seq_num --清算顺序号
,t1.tran_dt as tran_dt --交易日期
,t1.clear_dt as clear_dt --清算日期
,t1.actl_enter_acct_dt as actl_enter_acct_dt --实际入帐日期
,t1.chg_bf_clear_dt as chg_bf_clear_dt --变动前清算日期
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num --流水号
,replace(replace(t1.rela_flow_num,chr(13),''),chr(10),'') as rela_flow_num --关联流水号
,replace(replace(t1.intior_cd,chr(13),''),chr(10),'') as intior_cd --发起方代码
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd --交易代码
,replace(replace(t1.bus_cd,chr(13),''),chr(10),'') as bus_cd --业务代码
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd --客户类型代码
,replace(replace(t1.intnal_cust_id,chr(13),''),chr(10),'') as intnal_cust_id --内部客户编号
,replace(replace(t1.bank_id,chr(13),''),chr(10),'') as bank_id --银行编号
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --交易客户编号
,replace(replace(t1.bank_acct_num,chr(13),''),chr(10),'') as bank_acct_num --银行账号
,replace(replace(t1.bank_acct_type_cd,chr(13),''),chr(10),'') as bank_acct_type_cd --银行帐户类型代码
,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd --交易渠道代码
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id --交易柜员编号
,replace(replace(t1.termn_id,chr(13),''),chr(10),'') as termn_id --交易终端编号
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id --交易机构编号
,replace(replace(t1.tran_belong_org_id,chr(13),''),chr(10),'') as tran_belong_org_id --交易所属机构编号
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd --TA代码
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id --产品编号
,replace(replace(t1.acct_dir_cd,chr(13),''),chr(10),'') as acct_dir_cd --账务方向代码
,t1.clear_amt as clear_amt --清算金额
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,replace(replace(t1.ec_idf_cd,chr(13),''),chr(10),'') as ec_idf_cd --钞汇标识代码
,t1.unfrz_amt as unfrz_amt --解冻金额
,replace(replace(t1.host_tran_code,chr(13),''),chr(10),'') as host_tran_code --主机交易码
,t1.host_dt as host_dt --主机日期
,replace(replace(t1.host_flow_num,chr(13),''),chr(10),'') as host_flow_num --主机流水号
,t1.froz_amt as froz_amt --冻结金额
,replace(replace(t1.bal_chk_cfm_cd,chr(13),''),chr(10),'') as bal_chk_cfm_cd --勾对确认代码
,replace(replace(t1.acct_amt_src_type_cd,chr(13),''),chr(10),'') as acct_amt_src_type_cd --上帐金额来源类型代码
,replace(replace(t1.cap_cate_cd,chr(13),''),chr(10),'') as cap_cate_cd --资金类别代码
,replace(replace(t1.pric_prft_cd,chr(13),''),chr(10),'') as pric_prft_cd --本金收益代码
,t1.cfm_lot as cfm_lot --确认份额
,t1.pric_amt as pric_amt --本金金额
,t1.cfm_prft_amt as cfm_prft_amt --确认收益金额
,t1.lot_accu_accum as lot_accu_accum --份额累积积数
,replace(replace(t1.prod_acct_num,chr(13),''),chr(10),'') as prod_acct_num --产品账号
,replace(replace(t1.prod_acct_type_cd,chr(13),''),chr(10),'') as prod_acct_type_cd --产品账户类型代码
,replace(replace(t1.memo_comnt,chr(13),''),chr(10),'') as memo_comnt --摘要说明
,replace(replace(t1.cap_clear_status_cd,chr(13),''),chr(10),'') as cap_clear_status_cd --资金清算状态代码
,replace(replace(t1.init_clear_flow_num,chr(13),''),chr(10),'') as init_clear_flow_num --原清算流水号
,replace(replace(t1.return_code,chr(13),''),chr(10),'') as return_code --返回码
,replace(replace(t1.err_info_desc,chr(13),''),chr(10),'') as err_info_desc --错误信息描述
,replace(replace(t1.intfc_proc_flg,chr(13),''),chr(10),'') as intfc_proc_flg --接口处理标志
,replace(replace(t1.remark_info_1,chr(13),''),chr(10),'') as remark_info_1 --备注信息1
,replace(replace(t1.remark_info_2,chr(13),''),chr(10),'') as remark_info_2 --备注信息2
,replace(replace(t1.remark_info_3,chr(13),''),chr(10),'') as remark_info_3 --备注信息3
,replace(replace(t1.remark_info_4,chr(13),''),chr(10),'') as remark_info_4 --备注信息4
,replace(replace(t1.remark_info_5,chr(13),''),chr(10),'') as remark_info_5 --备注信息5
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id --事件编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.evt_finc_cap_clear t1    --理财资金清算
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_evt_finc_cap_clear',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
