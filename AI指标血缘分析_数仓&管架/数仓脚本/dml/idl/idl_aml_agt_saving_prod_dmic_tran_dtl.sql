/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_agt_saving_prod_dmic_tran_dtl
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl drop partition p_${last_date};
alter table ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl (
    etl_dt  -- 数据日期
    ,agt_id  -- 协议编号
    ,lp_id  -- 法人编号
    ,dtl_seq_num  -- 明细序号
    ,liab_acct_num  -- 负债账号
    ,acct_name  -- 账户名称
    ,bal_name_field  -- 余额名称字段
    ,tran_amt  -- 交易金额
    ,bal  -- 余额
    ,cust_acct_num  -- 客户账号
    ,acct_num_seq_num  -- 账号序号
    ,prod_id  -- 产品编号
    ,debit_crdt_flg  -- 借贷标志
    ,tran_curr_cd  -- 交易币种代码
    ,ec_flg  -- 钞汇标志
    ,prod_belong_obj_cd  -- 产品所属对象代码
    ,cash_trans_cd  -- 现转代码
    ,cntpty_fin_inst_type_cd  -- 对方金融机构类型代码
    ,rec_status_cd  -- 记录状态代码
    ,dep_term  -- 存期代码
    ,vouch_kind_cd  -- 凭证种类代码
    ,vouch_batch_no  -- 凭证批号
    ,vouch_seq_num  -- 凭证序号
    ,tran_chn  -- 交易渠道代码
    ,ext_tran_code  -- 外部交易码
    ,intnal_tran_code  -- 内部交易码
    ,tran_org_id  -- 交易机构编号
    ,tran_acct_instit_id  -- 交易账务机构编号
    ,open_acct_org_id  -- 开户机构编号
    ,acct_acct_instit_id  -- 账户账务机构编号
    ,operr_id  -- 操作员编号
    ,cntpty_cust_acct_num  -- 对方客户账号
    ,cntpty_acct_name  -- 对方账户名称
    ,cntpty_fin_inst_name  -- 对方金融机构名称
    ,cntpty_acct_open_bank_num  -- 交易对手账户开户行号
    ,teller_flow_num  -- 柜员流水号
    ,trast_dt  -- 办理日期
    ,trast_tm  -- 办理时间
    ,host_dt  -- 主机日期
    ,revs_cd  -- 冲正代码
    ,brevs_flg  -- 被冲正标志
    ,wa_init_dt  -- 错账原日期
    ,wa_init_teller_flow_num  -- 错账原柜员流水号
    ,tran_proc_char  -- 交易处理性质
    ,matn_teller_id  -- 维护柜员编号
    ,matn_org_id  -- 维护机构编号
    ,matn_dt  -- 维护日期
    ,matn_tm  -- 维护时间
    ,update_tm_stamp  -- 更新时间戳
    ,memo_id  -- 摘要编号
    ,memo_descb  -- 摘要描述
    ,cntpty_acct_num  -- 对方账号
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.agt_id,chr(13),''),chr(10),'')  -- 协议编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,t1.dtl_seq_num  -- 明细序号
    ,replace(replace(t1.liab_acct_num,chr(13),''),chr(10),'')  -- 负债账号
    ,replace(replace(t1.acct_name,chr(13),''),chr(10),'')  -- 账户名称
    ,replace(replace(t1.bal_name_field,chr(13),''),chr(10),'')  -- 余额名称字段
    ,t1.tran_amt  -- 交易金额
    ,t1.bal  -- 余额
    ,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'')  -- 客户账号
    ,replace(replace(t1.acct_num_seq_num,chr(13),''),chr(10),'')  -- 账号序号
    ,replace(replace(t1.prod_id,chr(13),''),chr(10),'')  -- 产品编号
    ,replace(replace(t1.debit_crdt_flg,chr(13),''),chr(10),'')  -- 借贷标志
    ,replace(replace(t1.tran_curr_cd,chr(13),''),chr(10),'')  -- 交易币种代码
    ,replace(replace(t1.ec_flg,chr(13),''),chr(10),'')  -- 钞汇标志
    ,replace(replace(t1.prod_belong_obj_cd,chr(13),''),chr(10),'')  -- 产品所属对象代码
    ,replace(replace(t1.cash_trans_cd,chr(13),''),chr(10),'')  -- 现转代码
    ,replace(replace(t1.cntpty_fin_inst_type_cd,chr(13),''),chr(10),'')  -- 对方金融机构类型代码
    ,replace(replace(t1.rec_status_cd,chr(13),''),chr(10),'')  -- 记录状态代码
    ,replace(replace(t1.dep_term,chr(13),''),chr(10),'')  -- 存期代码
    ,replace(replace(t1.vouch_kind_cd,chr(13),''),chr(10),'')  -- 凭证种类代码
    ,replace(replace(t1.vouch_batch_no,chr(13),''),chr(10),'')  -- 凭证批号
    ,replace(replace(t1.vouch_seq_num,chr(13),''),chr(10),'')  -- 凭证序号
    ,replace(replace(t1.tran_chn,chr(13),''),chr(10),'')  -- 交易渠道代码
    ,replace(replace(t1.ext_tran_code,chr(13),''),chr(10),'')  -- 外部交易码
    ,replace(replace(t1.intnal_tran_code,chr(13),''),chr(10),'')  -- 内部交易码
    ,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'')  -- 交易机构编号
    ,replace(replace(t1.tran_acct_instit_id,chr(13),''),chr(10),'')  -- 交易账务机构编号
    ,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'')  -- 开户机构编号
    ,replace(replace(t1.acct_acct_instit_id,chr(13),''),chr(10),'')  -- 账户账务机构编号
    ,replace(replace(t1.operr_id,chr(13),''),chr(10),'')  -- 操作员编号
    ,replace(replace(t1.cntpty_cust_acct_num,chr(13),''),chr(10),'')  -- 对方客户账号
    ,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'')  -- 对方账户名称
    ,replace(replace(t1.cntpty_fin_inst_name,chr(13),''),chr(10),'')  -- 对方金融机构名称
    ,replace(replace(t1.cntpty_acct_open_bank_num,chr(13),''),chr(10),'')  -- 交易对手账户开户行号
    ,replace(replace(t1.teller_flow_num,chr(13),''),chr(10),'')  -- 柜员流水号
    ,t1.trast_dt  -- 办理日期
    ,replace(replace(t1.trast_tm,chr(13),''),chr(10),'')  -- 办理时间
    ,t1.host_dt  -- 主机日期
    ,replace(replace(t1.revs_cd,chr(13),''),chr(10),'')  -- 冲正代码
    ,replace(replace(t1.brevs_flg,chr(13),''),chr(10),'')  -- 被冲正标志
    ,t1.wa_init_dt  -- 错账原日期
    ,replace(replace(t1.wa_init_teller_flow_num,chr(13),''),chr(10),'')  -- 错账原柜员流水号
    ,replace(replace(t1.tran_proc_char,chr(13),''),chr(10),'')  -- 交易处理性质
    ,replace(replace(t1.matn_teller_id,chr(13),''),chr(10),'')  -- 维护柜员编号
    ,replace(replace(t1.matn_org_id,chr(13),''),chr(10),'')  -- 维护机构编号
    ,t1.matn_dt  -- 维护日期
    ,replace(replace(t1.matn_tm,chr(13),''),chr(10),'')  -- 维护时间
    ,t1.update_tm_stamp  -- 更新时间戳
    ,replace(replace(t1.memo_id,chr(13),''),chr(10),'')  -- 摘要编号
    ,replace(replace(t1.memo_descb,chr(13),''),chr(10),'')  -- 摘要描述
    ,replace(replace(t1.cntpty_acct_num,chr(13),''),chr(10),'')  -- 对方账号
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iml_schema}.agt_saving_prod_dmic_tran_dtl t1    --储蓄产品户动账交易明细
where t1.trast_dt = to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_agt_saving_prod_dmic_tran_dtl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);