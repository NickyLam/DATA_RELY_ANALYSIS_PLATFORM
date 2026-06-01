/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ppps_tran_batch_info_pppsf1
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
alter table ${iml_schema}.agt_ppps_tran_batch_info add partition p_pppsf1 values ('pppsf1')(
        subpartition p_pppsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_pppsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ppps_tran_batch_info_pppsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ppps_tran_batch_info partition for ('pppsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_ppps_tran_batch_info_pppsf1_tm purge;
drop table ${iml_schema}.agt_ppps_tran_batch_info_pppsf1_op purge;
drop table ${iml_schema}.agt_ppps_tran_batch_info_pppsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ppps_tran_batch_info_pppsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,chn_id -- 渠道编号
    ,chn_tran_flow_num -- 渠道交易流水号
    ,chn_tran_dt -- 渠道交易日期
    ,mercht_id -- 商户编号
    ,chn_sys_cd -- 渠道系统代码
    ,ova_flow_num -- 全局流水号
    ,tran_batch_no -- 交易批次号
    ,tran_dt -- 交易日期
    ,tran_batch_status_cd -- 交易批次状态代码
    ,sys_id -- 系统编号
    ,tran_cate_cd -- 交易类别代码
    ,tran_type_cd -- 转接类型代码
    ,curr_cd -- 币种代码
    ,tot_tran_amt -- 总交易金额
    ,tot_tran_cnt -- 总交易笔数
    ,fail_amt -- 失败金额
    ,fail_cnt -- 失败笔数
    ,sucs_amt -- 成功金额
    ,sucs_cnt -- 成功笔数
    ,plat_return_code -- 平台返回码
    ,plat_return_descb -- 平台返回描述
    ,src_agt_id -- 源协议编号
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,fee_id -- 费用编号
    ,fee_descb -- 费用描述
    ,inside_acct_flg -- 内部户标志
    ,intnal_acct_id -- 内部账户编号
    ,intnal_acct_name -- 内部账户名称
    ,corp_acct_id -- 对公账户编号
    ,corp_acct_name -- 对公账户名称
    ,sign_flg -- 签约标志
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,check_teller_id -- 复核柜员编号
    ,tran_org_id -- 交易机构编号
    ,final_update_dt -- 最后更新日期
    ,remark -- 备注
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ppps_tran_batch_info partition for ('pppsf1')
where 0=1
;

create table ${iml_schema}.agt_ppps_tran_batch_info_pppsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ppps_tran_batch_info partition for ('pppsf1') where 0=1;

create table ${iml_schema}.agt_ppps_tran_batch_info_pppsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ppps_tran_batch_info partition for ('pppsf1') where 0=1;

-- 3.1 get new data into table
-- ppps_t_txn_batch-1
insert into ${iml_schema}.agt_ppps_tran_batch_info_pppsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,chn_id -- 渠道编号
    ,chn_tran_flow_num -- 渠道交易流水号
    ,chn_tran_dt -- 渠道交易日期
    ,mercht_id -- 商户编号
    ,chn_sys_cd -- 渠道系统代码
    ,ova_flow_num -- 全局流水号
    ,tran_batch_no -- 交易批次号
    ,tran_dt -- 交易日期
    ,tran_batch_status_cd -- 交易批次状态代码
    ,sys_id -- 系统编号
    ,tran_cate_cd -- 交易类别代码
    ,tran_type_cd -- 转接类型代码
    ,curr_cd -- 币种代码
    ,tot_tran_amt -- 总交易金额
    ,tot_tran_cnt -- 总交易笔数
    ,fail_amt -- 失败金额
    ,fail_cnt -- 失败笔数
    ,sucs_amt -- 成功金额
    ,sucs_cnt -- 成功笔数
    ,plat_return_code -- 平台返回码
    ,plat_return_descb -- 平台返回描述
    ,src_agt_id -- 源协议编号
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,fee_id -- 费用编号
    ,fee_descb -- 费用描述
    ,inside_acct_flg -- 内部户标志
    ,intnal_acct_id -- 内部账户编号
    ,intnal_acct_name -- 内部账户名称
    ,corp_acct_id -- 对公账户编号
    ,corp_acct_name -- 对公账户名称
    ,sign_flg -- 签约标志
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,check_teller_id -- 复核柜员编号
    ,tran_org_id -- 交易机构编号
    ,final_update_dt -- 最后更新日期
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300055'||P1.MCHT_NO||P1.TRAN_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.MCHT_NO -- 渠道编号
    ,P1.TRAN_NO -- 渠道交易流水号
    ,${iml_schema}.dateformat_max2(P1.TRAN_DATE||P1.TRAN_TIME) -- 渠道交易日期
    ,P1.MER_ID -- 商户编号
    ,nvl(trim(P1.CONSUMER_ID),'-') -- 渠道系统代码
    ,P1.GLOBAL_NO -- 全局流水号
    ,P1.BATCH_NO -- 交易批次号
    ,${iml_schema}.dateformat_max2(P1.BATCH_DATE||P1.BATCH_TIME) -- 交易日期
    ,nvl(trim(P1.BATCH_STATUS),'-') -- 交易批次状态代码
    ,P1.SYS_ID -- 系统编号
    ,nvl(trim(P1.TRADE_TYPE),'-') -- 交易类别代码
    ,nvl(trim(P1.SWITCH_TYPE),'-') -- 转接类型代码
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,P1.TOTAL_AMOUNT -- 总交易金额
    ,P1.TOTAL_COUNT -- 总交易笔数
    ,P1.FAIL_AMOUNT -- 失败金额
    ,P1.FAIL_COUNT -- 失败笔数
    ,P1.SUCCESS_AMOUNT -- 成功金额
    ,P1.SUCCESS_COUNT -- 成功笔数
    ,P1.RET_CODE -- 平台返回码
    ,P1.RET_MSG -- 平台返回描述
    ,P1.PROTOCOL_NO -- 源协议编号
    ,P1.PAYEE_ACCT_NO -- 收款账户编号
    ,P1.PAYEE_ACCT_NAME -- 收款账户名称
    ,P1.BILL_CODE -- 费用编号
    ,P1.BILL_INFO -- 费用描述
    ,decode(P1.INTER_ACCT_FLAG,' ','-','Y','1','N','0',P1.INTER_ACCT_FLAG) -- 内部户标志
    ,P1.INTRA_ACCT_NO -- 内部账户编号
    ,P1.INTRA_ACCT_NAME -- 内部账户名称
    ,P1.CORP_ACCT_NUM -- 对公账户编号
    ,P1.CORP_ACCT_NAME -- 对公账户名称
    ,decode(P1.SIGN_FLAG,' ','-','Y','1','N','0',P1.SIGN_FLAG) -- 签约标志
    ,P1.TELLER_NO -- 交易柜员编号
    ,P1.AUTH_TELLER_NO -- 授权柜员编号
    ,P1.CHECK_TELLER_NO -- 复核柜员编号
    ,P1.TRANS_ORG_NO -- 交易机构编号
    ,${iml_schema}.dateformat_max2(P1.UPDATE_TIME) -- 最后更新日期
    ,P1.REMARK -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ppps_t_txn_batch' -- 源表名称
    ,'pppsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ppps_t_txn_batch p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_ppps_tran_batch_info_pppsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
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
        into ${iml_schema}.agt_ppps_tran_batch_info_pppsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,chn_id -- 渠道编号
    ,chn_tran_flow_num -- 渠道交易流水号
    ,chn_tran_dt -- 渠道交易日期
    ,mercht_id -- 商户编号
    ,chn_sys_cd -- 渠道系统代码
    ,ova_flow_num -- 全局流水号
    ,tran_batch_no -- 交易批次号
    ,tran_dt -- 交易日期
    ,tran_batch_status_cd -- 交易批次状态代码
    ,sys_id -- 系统编号
    ,tran_cate_cd -- 交易类别代码
    ,tran_type_cd -- 转接类型代码
    ,curr_cd -- 币种代码
    ,tot_tran_amt -- 总交易金额
    ,tot_tran_cnt -- 总交易笔数
    ,fail_amt -- 失败金额
    ,fail_cnt -- 失败笔数
    ,sucs_amt -- 成功金额
    ,sucs_cnt -- 成功笔数
    ,plat_return_code -- 平台返回码
    ,plat_return_descb -- 平台返回描述
    ,src_agt_id -- 源协议编号
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,fee_id -- 费用编号
    ,fee_descb -- 费用描述
    ,inside_acct_flg -- 内部户标志
    ,intnal_acct_id -- 内部账户编号
    ,intnal_acct_name -- 内部账户名称
    ,corp_acct_id -- 对公账户编号
    ,corp_acct_name -- 对公账户名称
    ,sign_flg -- 签约标志
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,check_teller_id -- 复核柜员编号
    ,tran_org_id -- 交易机构编号
    ,final_update_dt -- 最后更新日期
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ppps_tran_batch_info_pppsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,chn_id -- 渠道编号
    ,chn_tran_flow_num -- 渠道交易流水号
    ,chn_tran_dt -- 渠道交易日期
    ,mercht_id -- 商户编号
    ,chn_sys_cd -- 渠道系统代码
    ,ova_flow_num -- 全局流水号
    ,tran_batch_no -- 交易批次号
    ,tran_dt -- 交易日期
    ,tran_batch_status_cd -- 交易批次状态代码
    ,sys_id -- 系统编号
    ,tran_cate_cd -- 交易类别代码
    ,tran_type_cd -- 转接类型代码
    ,curr_cd -- 币种代码
    ,tot_tran_amt -- 总交易金额
    ,tot_tran_cnt -- 总交易笔数
    ,fail_amt -- 失败金额
    ,fail_cnt -- 失败笔数
    ,sucs_amt -- 成功金额
    ,sucs_cnt -- 成功笔数
    ,plat_return_code -- 平台返回码
    ,plat_return_descb -- 平台返回描述
    ,src_agt_id -- 源协议编号
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,fee_id -- 费用编号
    ,fee_descb -- 费用描述
    ,inside_acct_flg -- 内部户标志
    ,intnal_acct_id -- 内部账户编号
    ,intnal_acct_name -- 内部账户名称
    ,corp_acct_id -- 对公账户编号
    ,corp_acct_name -- 对公账户名称
    ,sign_flg -- 签约标志
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,check_teller_id -- 复核柜员编号
    ,tran_org_id -- 交易机构编号
    ,final_update_dt -- 最后更新日期
    ,remark -- 备注
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
    ,nvl(n.chn_id, o.chn_id) as chn_id -- 渠道编号
    ,nvl(n.chn_tran_flow_num, o.chn_tran_flow_num) as chn_tran_flow_num -- 渠道交易流水号
    ,nvl(n.chn_tran_dt, o.chn_tran_dt) as chn_tran_dt -- 渠道交易日期
    ,nvl(n.mercht_id, o.mercht_id) as mercht_id -- 商户编号
    ,nvl(n.chn_sys_cd, o.chn_sys_cd) as chn_sys_cd -- 渠道系统代码
    ,nvl(n.ova_flow_num, o.ova_flow_num) as ova_flow_num -- 全局流水号
    ,nvl(n.tran_batch_no, o.tran_batch_no) as tran_batch_no -- 交易批次号
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.tran_batch_status_cd, o.tran_batch_status_cd) as tran_batch_status_cd -- 交易批次状态代码
    ,nvl(n.sys_id, o.sys_id) as sys_id -- 系统编号
    ,nvl(n.tran_cate_cd, o.tran_cate_cd) as tran_cate_cd -- 交易类别代码
    ,nvl(n.tran_type_cd, o.tran_type_cd) as tran_type_cd -- 转接类型代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.tot_tran_amt, o.tot_tran_amt) as tot_tran_amt -- 总交易金额
    ,nvl(n.tot_tran_cnt, o.tot_tran_cnt) as tot_tran_cnt -- 总交易笔数
    ,nvl(n.fail_amt, o.fail_amt) as fail_amt -- 失败金额
    ,nvl(n.fail_cnt, o.fail_cnt) as fail_cnt -- 失败笔数
    ,nvl(n.sucs_amt, o.sucs_amt) as sucs_amt -- 成功金额
    ,nvl(n.sucs_cnt, o.sucs_cnt) as sucs_cnt -- 成功笔数
    ,nvl(n.plat_return_code, o.plat_return_code) as plat_return_code -- 平台返回码
    ,nvl(n.plat_return_descb, o.plat_return_descb) as plat_return_descb -- 平台返回描述
    ,nvl(n.src_agt_id, o.src_agt_id) as src_agt_id -- 源协议编号
    ,nvl(n.recvbl_acct_id, o.recvbl_acct_id) as recvbl_acct_id -- 收款账户编号
    ,nvl(n.recvbl_acct_name, o.recvbl_acct_name) as recvbl_acct_name -- 收款账户名称
    ,nvl(n.fee_id, o.fee_id) as fee_id -- 费用编号
    ,nvl(n.fee_descb, o.fee_descb) as fee_descb -- 费用描述
    ,nvl(n.inside_acct_flg, o.inside_acct_flg) as inside_acct_flg -- 内部户标志
    ,nvl(n.intnal_acct_id, o.intnal_acct_id) as intnal_acct_id -- 内部账户编号
    ,nvl(n.intnal_acct_name, o.intnal_acct_name) as intnal_acct_name -- 内部账户名称
    ,nvl(n.corp_acct_id, o.corp_acct_id) as corp_acct_id -- 对公账户编号
    ,nvl(n.corp_acct_name, o.corp_acct_name) as corp_acct_name -- 对公账户名称
    ,nvl(n.sign_flg, o.sign_flg) as sign_flg -- 签约标志
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.auth_teller_id, o.auth_teller_id) as auth_teller_id -- 授权柜员编号
    ,nvl(n.check_teller_id, o.check_teller_id) as check_teller_id -- 复核柜员编号
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ppps_tran_batch_info_pppsf1_tm n
    full join (select * from ${iml_schema}.agt_ppps_tran_batch_info_pppsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.chn_id <> n.chn_id
        or o.chn_tran_flow_num <> n.chn_tran_flow_num
        or o.chn_tran_dt <> n.chn_tran_dt
        or o.mercht_id <> n.mercht_id
        or o.chn_sys_cd <> n.chn_sys_cd
        or o.ova_flow_num <> n.ova_flow_num
        or o.tran_batch_no <> n.tran_batch_no
        or o.tran_dt <> n.tran_dt
        or o.tran_batch_status_cd <> n.tran_batch_status_cd
        or o.sys_id <> n.sys_id
        or o.tran_cate_cd <> n.tran_cate_cd
        or o.tran_type_cd <> n.tran_type_cd
        or o.curr_cd <> n.curr_cd
        or o.tot_tran_amt <> n.tot_tran_amt
        or o.tot_tran_cnt <> n.tot_tran_cnt
        or o.fail_amt <> n.fail_amt
        or o.fail_cnt <> n.fail_cnt
        or o.sucs_amt <> n.sucs_amt
        or o.sucs_cnt <> n.sucs_cnt
        or o.plat_return_code <> n.plat_return_code
        or o.plat_return_descb <> n.plat_return_descb
        or o.src_agt_id <> n.src_agt_id
        or o.recvbl_acct_id <> n.recvbl_acct_id
        or o.recvbl_acct_name <> n.recvbl_acct_name
        or o.fee_id <> n.fee_id
        or o.fee_descb <> n.fee_descb
        or o.inside_acct_flg <> n.inside_acct_flg
        or o.intnal_acct_id <> n.intnal_acct_id
        or o.intnal_acct_name <> n.intnal_acct_name
        or o.corp_acct_id <> n.corp_acct_id
        or o.corp_acct_name <> n.corp_acct_name
        or o.sign_flg <> n.sign_flg
        or o.tran_teller_id <> n.tran_teller_id
        or o.auth_teller_id <> n.auth_teller_id
        or o.check_teller_id <> n.check_teller_id
        or o.tran_org_id <> n.tran_org_id
        or o.final_update_dt <> n.final_update_dt
        or o.remark <> n.remark
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_ppps_tran_batch_info_pppsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,chn_id -- 渠道编号
    ,chn_tran_flow_num -- 渠道交易流水号
    ,chn_tran_dt -- 渠道交易日期
    ,mercht_id -- 商户编号
    ,chn_sys_cd -- 渠道系统代码
    ,ova_flow_num -- 全局流水号
    ,tran_batch_no -- 交易批次号
    ,tran_dt -- 交易日期
    ,tran_batch_status_cd -- 交易批次状态代码
    ,sys_id -- 系统编号
    ,tran_cate_cd -- 交易类别代码
    ,tran_type_cd -- 转接类型代码
    ,curr_cd -- 币种代码
    ,tot_tran_amt -- 总交易金额
    ,tot_tran_cnt -- 总交易笔数
    ,fail_amt -- 失败金额
    ,fail_cnt -- 失败笔数
    ,sucs_amt -- 成功金额
    ,sucs_cnt -- 成功笔数
    ,plat_return_code -- 平台返回码
    ,plat_return_descb -- 平台返回描述
    ,src_agt_id -- 源协议编号
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,fee_id -- 费用编号
    ,fee_descb -- 费用描述
    ,inside_acct_flg -- 内部户标志
    ,intnal_acct_id -- 内部账户编号
    ,intnal_acct_name -- 内部账户名称
    ,corp_acct_id -- 对公账户编号
    ,corp_acct_name -- 对公账户名称
    ,sign_flg -- 签约标志
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,check_teller_id -- 复核柜员编号
    ,tran_org_id -- 交易机构编号
    ,final_update_dt -- 最后更新日期
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ppps_tran_batch_info_pppsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,chn_id -- 渠道编号
    ,chn_tran_flow_num -- 渠道交易流水号
    ,chn_tran_dt -- 渠道交易日期
    ,mercht_id -- 商户编号
    ,chn_sys_cd -- 渠道系统代码
    ,ova_flow_num -- 全局流水号
    ,tran_batch_no -- 交易批次号
    ,tran_dt -- 交易日期
    ,tran_batch_status_cd -- 交易批次状态代码
    ,sys_id -- 系统编号
    ,tran_cate_cd -- 交易类别代码
    ,tran_type_cd -- 转接类型代码
    ,curr_cd -- 币种代码
    ,tot_tran_amt -- 总交易金额
    ,tot_tran_cnt -- 总交易笔数
    ,fail_amt -- 失败金额
    ,fail_cnt -- 失败笔数
    ,sucs_amt -- 成功金额
    ,sucs_cnt -- 成功笔数
    ,plat_return_code -- 平台返回码
    ,plat_return_descb -- 平台返回描述
    ,src_agt_id -- 源协议编号
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,fee_id -- 费用编号
    ,fee_descb -- 费用描述
    ,inside_acct_flg -- 内部户标志
    ,intnal_acct_id -- 内部账户编号
    ,intnal_acct_name -- 内部账户名称
    ,corp_acct_id -- 对公账户编号
    ,corp_acct_name -- 对公账户名称
    ,sign_flg -- 签约标志
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,check_teller_id -- 复核柜员编号
    ,tran_org_id -- 交易机构编号
    ,final_update_dt -- 最后更新日期
    ,remark -- 备注
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
    ,o.chn_id -- 渠道编号
    ,o.chn_tran_flow_num -- 渠道交易流水号
    ,o.chn_tran_dt -- 渠道交易日期
    ,o.mercht_id -- 商户编号
    ,o.chn_sys_cd -- 渠道系统代码
    ,o.ova_flow_num -- 全局流水号
    ,o.tran_batch_no -- 交易批次号
    ,o.tran_dt -- 交易日期
    ,o.tran_batch_status_cd -- 交易批次状态代码
    ,o.sys_id -- 系统编号
    ,o.tran_cate_cd -- 交易类别代码
    ,o.tran_type_cd -- 转接类型代码
    ,o.curr_cd -- 币种代码
    ,o.tot_tran_amt -- 总交易金额
    ,o.tot_tran_cnt -- 总交易笔数
    ,o.fail_amt -- 失败金额
    ,o.fail_cnt -- 失败笔数
    ,o.sucs_amt -- 成功金额
    ,o.sucs_cnt -- 成功笔数
    ,o.plat_return_code -- 平台返回码
    ,o.plat_return_descb -- 平台返回描述
    ,o.src_agt_id -- 源协议编号
    ,o.recvbl_acct_id -- 收款账户编号
    ,o.recvbl_acct_name -- 收款账户名称
    ,o.fee_id -- 费用编号
    ,o.fee_descb -- 费用描述
    ,o.inside_acct_flg -- 内部户标志
    ,o.intnal_acct_id -- 内部账户编号
    ,o.intnal_acct_name -- 内部账户名称
    ,o.corp_acct_id -- 对公账户编号
    ,o.corp_acct_name -- 对公账户名称
    ,o.sign_flg -- 签约标志
    ,o.tran_teller_id -- 交易柜员编号
    ,o.auth_teller_id -- 授权柜员编号
    ,o.check_teller_id -- 复核柜员编号
    ,o.tran_org_id -- 交易机构编号
    ,o.final_update_dt -- 最后更新日期
    ,o.remark -- 备注
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
from ${iml_schema}.agt_ppps_tran_batch_info_pppsf1_bk o
    left join ${iml_schema}.agt_ppps_tran_batch_info_pppsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_ppps_tran_batch_info_pppsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_ppps_tran_batch_info;
--alter table ${iml_schema}.agt_ppps_tran_batch_info truncate partition for ('pppsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_ppps_tran_batch_info') 
               and substr(subpartition_name,1,8)=upper('p_pppsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_ppps_tran_batch_info drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_ppps_tran_batch_info modify partition p_pppsf1 
add subpartition p_pppsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_ppps_tran_batch_info exchange subpartition p_pppsf1_${batch_date} with table ${iml_schema}.agt_ppps_tran_batch_info_pppsf1_cl;
alter table ${iml_schema}.agt_ppps_tran_batch_info exchange subpartition p_pppsf1_20991231 with table ${iml_schema}.agt_ppps_tran_batch_info_pppsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ppps_tran_batch_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_ppps_tran_batch_info_pppsf1_tm purge;
drop table ${iml_schema}.agt_ppps_tran_batch_info_pppsf1_op purge;
drop table ${iml_schema}.agt_ppps_tran_batch_info_pppsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_ppps_tran_batch_info_pppsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ppps_tran_batch_info', partname => 'p_pppsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
