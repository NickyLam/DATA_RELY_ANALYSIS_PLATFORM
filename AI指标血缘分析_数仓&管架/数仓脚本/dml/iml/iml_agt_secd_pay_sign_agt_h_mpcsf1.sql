/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_secd_pay_sign_agt_h_mpcsf1
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
alter table ${iml_schema}.agt_secd_pay_sign_agt_h add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mpcsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_secd_pay_sign_agt_h_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_secd_pay_sign_agt_h partition for ('mpcsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_secd_pay_sign_agt_h_mpcsf1_tm purge;
drop table ${iml_schema}.agt_secd_pay_sign_agt_h_mpcsf1_op purge;
drop table ${iml_schema}.agt_secd_pay_sign_agt_h_mpcsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_secd_pay_sign_agt_h_mpcsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,agt_sign_dt -- 协议签署日期
    ,init_dir_prtcpt_org_id -- 发起直接参与机构编号
    ,init_chn_flow_num -- 原渠道流水号
    ,init_agt_id -- 初始协议编号
    ,agt_status_cd -- 协议状态代码
    ,coll_agt_type_cd -- 代收协议类型代码
    ,stock_agt_flg -- 存量协议标志
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,update_tm -- 更新时间
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,nostro_cd -- 往来账代码
    ,acpt_pay_type_cd -- 收付款类型代码
    ,recver_acct_id -- 收款人账户编号
    ,recver_name -- 收款人名称
    ,recvbl_bank_no -- 收款行号
    ,recv_bank_name -- 收款行名称
    ,payer_acct_id -- 付款人账户编号
    ,payer_name -- 付款人名称
    ,payer_acct_type -- 付款人账户类型
    ,payer_open_bank_num -- 付款人开户行号
    ,pay_bank_bank_no -- 付款行行号
    ,pay_bank_name -- 付款行名称
    ,once_deduct_lmt -- 一次性扣款限额
    ,deduct_ped_int_lmt_cnt -- 扣款周期内限制笔数
    ,deduct_ped_inner_buckle_fee_lmt -- 扣款周期内扣费限额
    ,deduct_tm_corp -- 扣款时间单位
    ,deduct_tm_length -- 扣款时间长度
    ,deduct_tm_descb -- 扣款时间描述
    ,addit_info -- 附加信息
    ,err_info_desc -- 错误信息描述
    ,auth_mode_cd -- 授权模式代码
    ,postsc -- 附言
    ,whole_proc_idf -- 全行处理标识
    ,open_acct_org_id -- 开户机构编号
    ,tran_org_id -- 交易机构编号
    ,proc_org_id -- 处理机构编号
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_secd_pay_sign_agt_h partition for ('mpcsf1')
where 0=1
;

create table ${iml_schema}.agt_secd_pay_sign_agt_h_mpcsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_secd_pay_sign_agt_h partition for ('mpcsf1') where 0=1;

create table ${iml_schema}.agt_secd_pay_sign_agt_h_mpcsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_secd_pay_sign_agt_h partition for ('mpcsf1') where 0=1;

-- 3.1 get new data into table
-- mpcs_a08tbectrctinfo-1
insert into ${iml_schema}.agt_secd_pay_sign_agt_h_mpcsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,agt_sign_dt -- 协议签署日期
    ,init_dir_prtcpt_org_id -- 发起直接参与机构编号
    ,init_chn_flow_num -- 原渠道流水号
    ,init_agt_id -- 初始协议编号
    ,agt_status_cd -- 协议状态代码
    ,coll_agt_type_cd -- 代收协议类型代码
    ,stock_agt_flg -- 存量协议标志
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,update_tm -- 更新时间
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,nostro_cd -- 往来账代码
    ,acpt_pay_type_cd -- 收付款类型代码
    ,recver_acct_id -- 收款人账户编号
    ,recver_name -- 收款人名称
    ,recvbl_bank_no -- 收款行号
    ,recv_bank_name -- 收款行名称
    ,payer_acct_id -- 付款人账户编号
    ,payer_name -- 付款人名称
    ,payer_acct_type -- 付款人账户类型
    ,payer_open_bank_num -- 付款人开户行号
    ,pay_bank_bank_no -- 付款行行号
    ,pay_bank_name -- 付款行名称
    ,once_deduct_lmt -- 一次性扣款限额
    ,deduct_ped_int_lmt_cnt -- 扣款周期内限制笔数
    ,deduct_ped_inner_buckle_fee_lmt -- 扣款周期内扣费限额
    ,deduct_tm_corp -- 扣款时间单位
    ,deduct_tm_length -- 扣款时间长度
    ,deduct_tm_descb -- 扣款时间描述
    ,addit_info -- 附加信息
    ,err_info_desc -- 错误信息描述
    ,auth_mode_cd -- 授权模式代码
    ,postsc -- 附言
    ,whole_proc_idf -- 全行处理标识
    ,open_acct_org_id -- 开户机构编号
    ,tran_org_id -- 交易机构编号
    ,proc_org_id -- 处理机构编号
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300017'||P1.CTRCTNB -- 协议编号
    ,'9999' -- 法人编号
    ,P1.CTRCTNB -- 源协议编号
    ,${iml_schema}.dateformat_min(P1.CTRCTSGNDT) -- 协议签署日期
    ,P1.SNDUPBRN -- 发起直接参与机构编号
    ,P1.SRCSEQNO -- 原渠道流水号
    ,P1.ORICTRCTNB -- 初始协议编号
    ,P1.SIGNSTS -- 协议状态代码
    ,P1.CTRCTTP -- 代收协议类型代码
    ,P1.ISSTOCK -- 存量协议标志
    ,${iml_schema}.dateformat_max2(P1.ECTDT) -- 生效日期
    ,${iml_schema}.dateformat_max2(P1.CTRCTDUEDT) -- 失效日期
    ,${iml_schema}.dateformat_max2(P1.TRANSDT) -- 交易日期
    ,${iml_schema}.timeformat_min(P1.TRANSDT||P1.TRANSTM) -- 交易时间
    ,${iml_schema}.timeformat_min(regexp_replace(P1.UPTM,':','.',20,1)) -- 更新时间
    ,P1.CSTMRID -- 客户编号
    ,P1.CSTMRNM -- 客户名称
    ,P1.IOTYPE -- 往来账代码
    ,P1.PAYFLAG -- 收付款类型代码
    ,P1.INCOACCT -- 收款人账户编号
    ,P1.INCONAME -- 收款人名称
    ,P1.INCOBRN -- 收款行号
    ,P1.INCOBANKNM -- 收款行名称
    ,P1.PAYACCT -- 付款人账户编号
    ,P1.PAYNAME -- 付款人名称
    ,P1.CSTMRACCTTYPE -- 付款人账户类型
    ,P1.PAYOPENBRN -- 付款人开户行号
    ,P1.PAYBRN -- 付款行行号
    ,P1.PAYBANKNM -- 付款行名称
    ,nvl(replace((P1.ONCDDCTNLMT),',',''),0) -- 一次性扣款限额
    ,nvl(regexp_substr(P1.CYCDDCTNNUMLMT, '[0-9]+'),'0') -- 扣款周期内限制笔数
    ,nvl(replace((P1.CYCDDCTNLMT),',',''),0) -- 扣款周期内扣费限额
    ,P1.TMUT -- 扣款时间单位
    ,nvl(trim(P1.TMSP),0) -- 扣款时间长度
    ,P1.TMDC -- 扣款时间描述
    ,P1.CTRCTADDTLINF -- 附加信息
    ,P1.ERRMSG -- 错误信息描述
    ,P1.AUTHMD -- 授权模式代码
    ,P1.REMARK -- 附言
    ,P1.DEALFLAG -- 全行处理标识
    ,P1.OPENBRN -- 开户机构编号
    ,P1.BRCNO -- 交易机构编号
    ,P1.MAGBRN -- 处理机构编号
    ,P1.TLRNO -- 交易柜员编号
    ,P1.AUTHTLRNO -- 授权柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a08tbectrctinfo' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a08tbectrctinfo p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_secd_pay_sign_agt_h_mpcsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,src_agt_id
  	                                        ,agt_sign_dt
  	                                        ,init_dir_prtcpt_org_id
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
        into ${iml_schema}.agt_secd_pay_sign_agt_h_mpcsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,agt_sign_dt -- 协议签署日期
    ,init_dir_prtcpt_org_id -- 发起直接参与机构编号
    ,init_chn_flow_num -- 原渠道流水号
    ,init_agt_id -- 初始协议编号
    ,agt_status_cd -- 协议状态代码
    ,coll_agt_type_cd -- 代收协议类型代码
    ,stock_agt_flg -- 存量协议标志
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,update_tm -- 更新时间
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,nostro_cd -- 往来账代码
    ,acpt_pay_type_cd -- 收付款类型代码
    ,recver_acct_id -- 收款人账户编号
    ,recver_name -- 收款人名称
    ,recvbl_bank_no -- 收款行号
    ,recv_bank_name -- 收款行名称
    ,payer_acct_id -- 付款人账户编号
    ,payer_name -- 付款人名称
    ,payer_acct_type -- 付款人账户类型
    ,payer_open_bank_num -- 付款人开户行号
    ,pay_bank_bank_no -- 付款行行号
    ,pay_bank_name -- 付款行名称
    ,once_deduct_lmt -- 一次性扣款限额
    ,deduct_ped_int_lmt_cnt -- 扣款周期内限制笔数
    ,deduct_ped_inner_buckle_fee_lmt -- 扣款周期内扣费限额
    ,deduct_tm_corp -- 扣款时间单位
    ,deduct_tm_length -- 扣款时间长度
    ,deduct_tm_descb -- 扣款时间描述
    ,addit_info -- 附加信息
    ,err_info_desc -- 错误信息描述
    ,auth_mode_cd -- 授权模式代码
    ,postsc -- 附言
    ,whole_proc_idf -- 全行处理标识
    ,open_acct_org_id -- 开户机构编号
    ,tran_org_id -- 交易机构编号
    ,proc_org_id -- 处理机构编号
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_secd_pay_sign_agt_h_mpcsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,agt_sign_dt -- 协议签署日期
    ,init_dir_prtcpt_org_id -- 发起直接参与机构编号
    ,init_chn_flow_num -- 原渠道流水号
    ,init_agt_id -- 初始协议编号
    ,agt_status_cd -- 协议状态代码
    ,coll_agt_type_cd -- 代收协议类型代码
    ,stock_agt_flg -- 存量协议标志
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,update_tm -- 更新时间
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,nostro_cd -- 往来账代码
    ,acpt_pay_type_cd -- 收付款类型代码
    ,recver_acct_id -- 收款人账户编号
    ,recver_name -- 收款人名称
    ,recvbl_bank_no -- 收款行号
    ,recv_bank_name -- 收款行名称
    ,payer_acct_id -- 付款人账户编号
    ,payer_name -- 付款人名称
    ,payer_acct_type -- 付款人账户类型
    ,payer_open_bank_num -- 付款人开户行号
    ,pay_bank_bank_no -- 付款行行号
    ,pay_bank_name -- 付款行名称
    ,once_deduct_lmt -- 一次性扣款限额
    ,deduct_ped_int_lmt_cnt -- 扣款周期内限制笔数
    ,deduct_ped_inner_buckle_fee_lmt -- 扣款周期内扣费限额
    ,deduct_tm_corp -- 扣款时间单位
    ,deduct_tm_length -- 扣款时间长度
    ,deduct_tm_descb -- 扣款时间描述
    ,addit_info -- 附加信息
    ,err_info_desc -- 错误信息描述
    ,auth_mode_cd -- 授权模式代码
    ,postsc -- 附言
    ,whole_proc_idf -- 全行处理标识
    ,open_acct_org_id -- 开户机构编号
    ,tran_org_id -- 交易机构编号
    ,proc_org_id -- 处理机构编号
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
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
    ,nvl(n.src_agt_id, o.src_agt_id) as src_agt_id -- 源协议编号
    ,nvl(n.agt_sign_dt, o.agt_sign_dt) as agt_sign_dt -- 协议签署日期
    ,nvl(n.init_dir_prtcpt_org_id, o.init_dir_prtcpt_org_id) as init_dir_prtcpt_org_id -- 发起直接参与机构编号
    ,nvl(n.init_chn_flow_num, o.init_chn_flow_num) as init_chn_flow_num -- 原渠道流水号
    ,nvl(n.init_agt_id, o.init_agt_id) as init_agt_id -- 初始协议编号
    ,nvl(n.agt_status_cd, o.agt_status_cd) as agt_status_cd -- 协议状态代码
    ,nvl(n.coll_agt_type_cd, o.coll_agt_type_cd) as coll_agt_type_cd -- 代收协议类型代码
    ,nvl(n.stock_agt_flg, o.stock_agt_flg) as stock_agt_flg -- 存量协议标志
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.update_tm, o.update_tm) as update_tm -- 更新时间
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.nostro_cd, o.nostro_cd) as nostro_cd -- 往来账代码
    ,nvl(n.acpt_pay_type_cd, o.acpt_pay_type_cd) as acpt_pay_type_cd -- 收付款类型代码
    ,nvl(n.recver_acct_id, o.recver_acct_id) as recver_acct_id -- 收款人账户编号
    ,nvl(n.recver_name, o.recver_name) as recver_name -- 收款人名称
    ,nvl(n.recvbl_bank_no, o.recvbl_bank_no) as recvbl_bank_no -- 收款行号
    ,nvl(n.recv_bank_name, o.recv_bank_name) as recv_bank_name -- 收款行名称
    ,nvl(n.payer_acct_id, o.payer_acct_id) as payer_acct_id -- 付款人账户编号
    ,nvl(n.payer_name, o.payer_name) as payer_name -- 付款人名称
    ,nvl(n.payer_acct_type, o.payer_acct_type) as payer_acct_type -- 付款人账户类型
    ,nvl(n.payer_open_bank_num, o.payer_open_bank_num) as payer_open_bank_num -- 付款人开户行号
    ,nvl(n.pay_bank_bank_no, o.pay_bank_bank_no) as pay_bank_bank_no -- 付款行行号
    ,nvl(n.pay_bank_name, o.pay_bank_name) as pay_bank_name -- 付款行名称
    ,nvl(n.once_deduct_lmt, o.once_deduct_lmt) as once_deduct_lmt -- 一次性扣款限额
    ,nvl(n.deduct_ped_int_lmt_cnt, o.deduct_ped_int_lmt_cnt) as deduct_ped_int_lmt_cnt -- 扣款周期内限制笔数
    ,nvl(n.deduct_ped_inner_buckle_fee_lmt, o.deduct_ped_inner_buckle_fee_lmt) as deduct_ped_inner_buckle_fee_lmt -- 扣款周期内扣费限额
    ,nvl(n.deduct_tm_corp, o.deduct_tm_corp) as deduct_tm_corp -- 扣款时间单位
    ,nvl(n.deduct_tm_length, o.deduct_tm_length) as deduct_tm_length -- 扣款时间长度
    ,nvl(n.deduct_tm_descb, o.deduct_tm_descb) as deduct_tm_descb -- 扣款时间描述
    ,nvl(n.addit_info, o.addit_info) as addit_info -- 附加信息
    ,nvl(n.err_info_desc, o.err_info_desc) as err_info_desc -- 错误信息描述
    ,nvl(n.auth_mode_cd, o.auth_mode_cd) as auth_mode_cd -- 授权模式代码
    ,nvl(n.postsc, o.postsc) as postsc -- 附言
    ,nvl(n.whole_proc_idf, o.whole_proc_idf) as whole_proc_idf -- 全行处理标识
    ,nvl(n.open_acct_org_id, o.open_acct_org_id) as open_acct_org_id -- 开户机构编号
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.proc_org_id, o.proc_org_id) as proc_org_id -- 处理机构编号
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.auth_teller_id, o.auth_teller_id) as auth_teller_id -- 授权柜员编号
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.src_agt_id is null
            and n.agt_sign_dt is null
            and n.init_dir_prtcpt_org_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.src_agt_id is null
            and n.agt_sign_dt is null
            and n.init_dir_prtcpt_org_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.src_agt_id is null
            and n.agt_sign_dt is null
            and n.init_dir_prtcpt_org_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_secd_pay_sign_agt_h_mpcsf1_tm n
    full join (select * from ${iml_schema}.agt_secd_pay_sign_agt_h_mpcsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.src_agt_id = n.src_agt_id
            and o.agt_sign_dt = n.agt_sign_dt
            and o.init_dir_prtcpt_org_id = n.init_dir_prtcpt_org_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.src_agt_id is null
        and o.agt_sign_dt is null
        and o.init_dir_prtcpt_org_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.src_agt_id is null
        and n.agt_sign_dt is null
        and n.init_dir_prtcpt_org_id is null
    )
    or (
        o.init_chn_flow_num <> n.init_chn_flow_num
        or o.init_agt_id <> n.init_agt_id
        or o.agt_status_cd <> n.agt_status_cd
        or o.coll_agt_type_cd <> n.coll_agt_type_cd
        or o.stock_agt_flg <> n.stock_agt_flg
        or o.effect_dt <> n.effect_dt
        or o.invalid_dt <> n.invalid_dt
        or o.tran_dt <> n.tran_dt
        or o.tran_tm <> n.tran_tm
        or o.update_tm <> n.update_tm
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.nostro_cd <> n.nostro_cd
        or o.acpt_pay_type_cd <> n.acpt_pay_type_cd
        or o.recver_acct_id <> n.recver_acct_id
        or o.recver_name <> n.recver_name
        or o.recvbl_bank_no <> n.recvbl_bank_no
        or o.recv_bank_name <> n.recv_bank_name
        or o.payer_acct_id <> n.payer_acct_id
        or o.payer_name <> n.payer_name
        or o.payer_acct_type <> n.payer_acct_type
        or o.payer_open_bank_num <> n.payer_open_bank_num
        or o.pay_bank_bank_no <> n.pay_bank_bank_no
        or o.pay_bank_name <> n.pay_bank_name
        or o.once_deduct_lmt <> n.once_deduct_lmt
        or o.deduct_ped_int_lmt_cnt <> n.deduct_ped_int_lmt_cnt
        or o.deduct_ped_inner_buckle_fee_lmt <> n.deduct_ped_inner_buckle_fee_lmt
        or o.deduct_tm_corp <> n.deduct_tm_corp
        or o.deduct_tm_length <> n.deduct_tm_length
        or o.deduct_tm_descb <> n.deduct_tm_descb
        or o.addit_info <> n.addit_info
        or o.err_info_desc <> n.err_info_desc
        or o.auth_mode_cd <> n.auth_mode_cd
        or o.postsc <> n.postsc
        or o.whole_proc_idf <> n.whole_proc_idf
        or o.open_acct_org_id <> n.open_acct_org_id
        or o.tran_org_id <> n.tran_org_id
        or o.proc_org_id <> n.proc_org_id
        or o.tran_teller_id <> n.tran_teller_id
        or o.auth_teller_id <> n.auth_teller_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_secd_pay_sign_agt_h_mpcsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,agt_sign_dt -- 协议签署日期
    ,init_dir_prtcpt_org_id -- 发起直接参与机构编号
    ,init_chn_flow_num -- 原渠道流水号
    ,init_agt_id -- 初始协议编号
    ,agt_status_cd -- 协议状态代码
    ,coll_agt_type_cd -- 代收协议类型代码
    ,stock_agt_flg -- 存量协议标志
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,update_tm -- 更新时间
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,nostro_cd -- 往来账代码
    ,acpt_pay_type_cd -- 收付款类型代码
    ,recver_acct_id -- 收款人账户编号
    ,recver_name -- 收款人名称
    ,recvbl_bank_no -- 收款行号
    ,recv_bank_name -- 收款行名称
    ,payer_acct_id -- 付款人账户编号
    ,payer_name -- 付款人名称
    ,payer_acct_type -- 付款人账户类型
    ,payer_open_bank_num -- 付款人开户行号
    ,pay_bank_bank_no -- 付款行行号
    ,pay_bank_name -- 付款行名称
    ,once_deduct_lmt -- 一次性扣款限额
    ,deduct_ped_int_lmt_cnt -- 扣款周期内限制笔数
    ,deduct_ped_inner_buckle_fee_lmt -- 扣款周期内扣费限额
    ,deduct_tm_corp -- 扣款时间单位
    ,deduct_tm_length -- 扣款时间长度
    ,deduct_tm_descb -- 扣款时间描述
    ,addit_info -- 附加信息
    ,err_info_desc -- 错误信息描述
    ,auth_mode_cd -- 授权模式代码
    ,postsc -- 附言
    ,whole_proc_idf -- 全行处理标识
    ,open_acct_org_id -- 开户机构编号
    ,tran_org_id -- 交易机构编号
    ,proc_org_id -- 处理机构编号
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_secd_pay_sign_agt_h_mpcsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,agt_sign_dt -- 协议签署日期
    ,init_dir_prtcpt_org_id -- 发起直接参与机构编号
    ,init_chn_flow_num -- 原渠道流水号
    ,init_agt_id -- 初始协议编号
    ,agt_status_cd -- 协议状态代码
    ,coll_agt_type_cd -- 代收协议类型代码
    ,stock_agt_flg -- 存量协议标志
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,update_tm -- 更新时间
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,nostro_cd -- 往来账代码
    ,acpt_pay_type_cd -- 收付款类型代码
    ,recver_acct_id -- 收款人账户编号
    ,recver_name -- 收款人名称
    ,recvbl_bank_no -- 收款行号
    ,recv_bank_name -- 收款行名称
    ,payer_acct_id -- 付款人账户编号
    ,payer_name -- 付款人名称
    ,payer_acct_type -- 付款人账户类型
    ,payer_open_bank_num -- 付款人开户行号
    ,pay_bank_bank_no -- 付款行行号
    ,pay_bank_name -- 付款行名称
    ,once_deduct_lmt -- 一次性扣款限额
    ,deduct_ped_int_lmt_cnt -- 扣款周期内限制笔数
    ,deduct_ped_inner_buckle_fee_lmt -- 扣款周期内扣费限额
    ,deduct_tm_corp -- 扣款时间单位
    ,deduct_tm_length -- 扣款时间长度
    ,deduct_tm_descb -- 扣款时间描述
    ,addit_info -- 附加信息
    ,err_info_desc -- 错误信息描述
    ,auth_mode_cd -- 授权模式代码
    ,postsc -- 附言
    ,whole_proc_idf -- 全行处理标识
    ,open_acct_org_id -- 开户机构编号
    ,tran_org_id -- 交易机构编号
    ,proc_org_id -- 处理机构编号
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
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
    ,o.src_agt_id -- 源协议编号
    ,o.agt_sign_dt -- 协议签署日期
    ,o.init_dir_prtcpt_org_id -- 发起直接参与机构编号
    ,o.init_chn_flow_num -- 原渠道流水号
    ,o.init_agt_id -- 初始协议编号
    ,o.agt_status_cd -- 协议状态代码
    ,o.coll_agt_type_cd -- 代收协议类型代码
    ,o.stock_agt_flg -- 存量协议标志
    ,o.effect_dt -- 生效日期
    ,o.invalid_dt -- 失效日期
    ,o.tran_dt -- 交易日期
    ,o.tran_tm -- 交易时间
    ,o.update_tm -- 更新时间
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.nostro_cd -- 往来账代码
    ,o.acpt_pay_type_cd -- 收付款类型代码
    ,o.recver_acct_id -- 收款人账户编号
    ,o.recver_name -- 收款人名称
    ,o.recvbl_bank_no -- 收款行号
    ,o.recv_bank_name -- 收款行名称
    ,o.payer_acct_id -- 付款人账户编号
    ,o.payer_name -- 付款人名称
    ,o.payer_acct_type -- 付款人账户类型
    ,o.payer_open_bank_num -- 付款人开户行号
    ,o.pay_bank_bank_no -- 付款行行号
    ,o.pay_bank_name -- 付款行名称
    ,o.once_deduct_lmt -- 一次性扣款限额
    ,o.deduct_ped_int_lmt_cnt -- 扣款周期内限制笔数
    ,o.deduct_ped_inner_buckle_fee_lmt -- 扣款周期内扣费限额
    ,o.deduct_tm_corp -- 扣款时间单位
    ,o.deduct_tm_length -- 扣款时间长度
    ,o.deduct_tm_descb -- 扣款时间描述
    ,o.addit_info -- 附加信息
    ,o.err_info_desc -- 错误信息描述
    ,o.auth_mode_cd -- 授权模式代码
    ,o.postsc -- 附言
    ,o.whole_proc_idf -- 全行处理标识
    ,o.open_acct_org_id -- 开户机构编号
    ,o.tran_org_id -- 交易机构编号
    ,o.proc_org_id -- 处理机构编号
    ,o.tran_teller_id -- 交易柜员编号
    ,o.auth_teller_id -- 授权柜员编号
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
from ${iml_schema}.agt_secd_pay_sign_agt_h_mpcsf1_bk o
    left join ${iml_schema}.agt_secd_pay_sign_agt_h_mpcsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.src_agt_id = n.src_agt_id
            and o.agt_sign_dt = n.agt_sign_dt
            and o.init_dir_prtcpt_org_id = n.init_dir_prtcpt_org_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_secd_pay_sign_agt_h_mpcsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.src_agt_id = d.src_agt_id
            and o.agt_sign_dt = d.agt_sign_dt
            and o.init_dir_prtcpt_org_id = d.init_dir_prtcpt_org_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_secd_pay_sign_agt_h;
--alter table ${iml_schema}.agt_secd_pay_sign_agt_h truncate partition for ('mpcsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_secd_pay_sign_agt_h') 
               and substr(subpartition_name,1,8)=upper('p_mpcsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_secd_pay_sign_agt_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_secd_pay_sign_agt_h modify partition p_mpcsf1 
add subpartition p_mpcsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_secd_pay_sign_agt_h exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.agt_secd_pay_sign_agt_h_mpcsf1_cl;
alter table ${iml_schema}.agt_secd_pay_sign_agt_h exchange subpartition p_mpcsf1_20991231 with table ${iml_schema}.agt_secd_pay_sign_agt_h_mpcsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_secd_pay_sign_agt_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_secd_pay_sign_agt_h_mpcsf1_tm purge;
drop table ${iml_schema}.agt_secd_pay_sign_agt_h_mpcsf1_op purge;
drop table ${iml_schema}.agt_secd_pay_sign_agt_h_mpcsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_secd_pay_sign_agt_h_mpcsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_secd_pay_sign_agt_h', partname => 'p_mpcsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
