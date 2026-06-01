/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_oppnet
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.isbs_oppnet_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_oppnet
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_oppnet_op purge;
drop table ${iol_schema}.isbs_oppnet_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_oppnet_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_oppnet where 0=1;

create table ${iol_schema}.isbs_oppnet_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_oppnet where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_oppnet_cl(
            inr -- 主键inr
            ,gltyp -- 接口表
            ,glinr -- 接口表的inr
            ,gldate -- 记账日期
            ,trninr -- trn表的inr
            ,core_tran_flow_num -- 全局流水号
            ,biz_seq_num -- 系统流水号
            ,biz_seq_no -- 交易序号
            ,biz_ccy -- 币种
            ,biz_amt -- 金额
            ,pty_extkey -- 分录账号的客户号
            ,pty_name -- 分录账号的名称
            ,pty_acct_num -- 分录账号
            ,pty_acct_no -- 分录账号序号
            ,tran_type -- 借贷方向
            ,tx_cntpty_acct_num -- 交易对手账号
            ,tx_cntpty_name -- 交易对手名称
            ,cntpty_fin_inst_brac_cd -- 交易对手行号
            ,cntpty_fin_inst_brac_name -- 交易对手行名
            ,dist -- 对手银行所在地行政区划
            ,tx_cntpty_cert_type -- 交易对手证件类型
            ,tx_cntpty_cert_type_txt -- 交易对手证件类型中文描述
            ,tx_cntpty_cert_no -- 交易对手证件号码
            ,cd_typ -- 交易对手行号类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_oppnet_op(
            inr -- 主键inr
            ,gltyp -- 接口表
            ,glinr -- 接口表的inr
            ,gldate -- 记账日期
            ,trninr -- trn表的inr
            ,core_tran_flow_num -- 全局流水号
            ,biz_seq_num -- 系统流水号
            ,biz_seq_no -- 交易序号
            ,biz_ccy -- 币种
            ,biz_amt -- 金额
            ,pty_extkey -- 分录账号的客户号
            ,pty_name -- 分录账号的名称
            ,pty_acct_num -- 分录账号
            ,pty_acct_no -- 分录账号序号
            ,tran_type -- 借贷方向
            ,tx_cntpty_acct_num -- 交易对手账号
            ,tx_cntpty_name -- 交易对手名称
            ,cntpty_fin_inst_brac_cd -- 交易对手行号
            ,cntpty_fin_inst_brac_name -- 交易对手行名
            ,dist -- 对手银行所在地行政区划
            ,tx_cntpty_cert_type -- 交易对手证件类型
            ,tx_cntpty_cert_type_txt -- 交易对手证件类型中文描述
            ,tx_cntpty_cert_no -- 交易对手证件号码
            ,cd_typ -- 交易对手行号类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 主键inr
    ,nvl(n.gltyp, o.gltyp) as gltyp -- 接口表
    ,nvl(n.glinr, o.glinr) as glinr -- 接口表的inr
    ,nvl(n.gldate, o.gldate) as gldate -- 记账日期
    ,nvl(n.trninr, o.trninr) as trninr -- trn表的inr
    ,nvl(n.core_tran_flow_num, o.core_tran_flow_num) as core_tran_flow_num -- 全局流水号
    ,nvl(n.biz_seq_num, o.biz_seq_num) as biz_seq_num -- 系统流水号
    ,nvl(n.biz_seq_no, o.biz_seq_no) as biz_seq_no -- 交易序号
    ,nvl(n.biz_ccy, o.biz_ccy) as biz_ccy -- 币种
    ,nvl(n.biz_amt, o.biz_amt) as biz_amt -- 金额
    ,nvl(n.pty_extkey, o.pty_extkey) as pty_extkey -- 分录账号的客户号
    ,nvl(n.pty_name, o.pty_name) as pty_name -- 分录账号的名称
    ,nvl(n.pty_acct_num, o.pty_acct_num) as pty_acct_num -- 分录账号
    ,nvl(n.pty_acct_no, o.pty_acct_no) as pty_acct_no -- 分录账号序号
    ,nvl(n.tran_type, o.tran_type) as tran_type -- 借贷方向
    ,nvl(n.tx_cntpty_acct_num, o.tx_cntpty_acct_num) as tx_cntpty_acct_num -- 交易对手账号
    ,nvl(n.tx_cntpty_name, o.tx_cntpty_name) as tx_cntpty_name -- 交易对手名称
    ,nvl(n.cntpty_fin_inst_brac_cd, o.cntpty_fin_inst_brac_cd) as cntpty_fin_inst_brac_cd -- 交易对手行号
    ,nvl(n.cntpty_fin_inst_brac_name, o.cntpty_fin_inst_brac_name) as cntpty_fin_inst_brac_name -- 交易对手行名
    ,nvl(n.dist, o.dist) as dist -- 对手银行所在地行政区划
    ,nvl(n.tx_cntpty_cert_type, o.tx_cntpty_cert_type) as tx_cntpty_cert_type -- 交易对手证件类型
    ,nvl(n.tx_cntpty_cert_type_txt, o.tx_cntpty_cert_type_txt) as tx_cntpty_cert_type_txt -- 交易对手证件类型中文描述
    ,nvl(n.tx_cntpty_cert_no, o.tx_cntpty_cert_no) as tx_cntpty_cert_no -- 交易对手证件号码
    ,nvl(n.cd_typ, o.cd_typ) as cd_typ -- 交易对手行号类型
    ,case when
            n.inr is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.inr is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.inr is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.isbs_oppnet_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_oppnet where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.gltyp <> n.gltyp
        or o.glinr <> n.glinr
        or o.gldate <> n.gldate
        or o.trninr <> n.trninr
        or o.core_tran_flow_num <> n.core_tran_flow_num
        or o.biz_seq_num <> n.biz_seq_num
        or o.biz_seq_no <> n.biz_seq_no
        or o.biz_ccy <> n.biz_ccy
        or o.biz_amt <> n.biz_amt
        or o.pty_extkey <> n.pty_extkey
        or o.pty_name <> n.pty_name
        or o.pty_acct_num <> n.pty_acct_num
        or o.pty_acct_no <> n.pty_acct_no
        or o.tran_type <> n.tran_type
        or o.tx_cntpty_acct_num <> n.tx_cntpty_acct_num
        or o.tx_cntpty_name <> n.tx_cntpty_name
        or o.cntpty_fin_inst_brac_cd <> n.cntpty_fin_inst_brac_cd
        or o.cntpty_fin_inst_brac_name <> n.cntpty_fin_inst_brac_name
        or o.dist <> n.dist
        or o.tx_cntpty_cert_type <> n.tx_cntpty_cert_type
        or o.tx_cntpty_cert_type_txt <> n.tx_cntpty_cert_type_txt
        or o.tx_cntpty_cert_no <> n.tx_cntpty_cert_no
        or o.cd_typ <> n.cd_typ
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_oppnet_cl(
            inr -- 主键inr
            ,gltyp -- 接口表
            ,glinr -- 接口表的inr
            ,gldate -- 记账日期
            ,trninr -- trn表的inr
            ,core_tran_flow_num -- 全局流水号
            ,biz_seq_num -- 系统流水号
            ,biz_seq_no -- 交易序号
            ,biz_ccy -- 币种
            ,biz_amt -- 金额
            ,pty_extkey -- 分录账号的客户号
            ,pty_name -- 分录账号的名称
            ,pty_acct_num -- 分录账号
            ,pty_acct_no -- 分录账号序号
            ,tran_type -- 借贷方向
            ,tx_cntpty_acct_num -- 交易对手账号
            ,tx_cntpty_name -- 交易对手名称
            ,cntpty_fin_inst_brac_cd -- 交易对手行号
            ,cntpty_fin_inst_brac_name -- 交易对手行名
            ,dist -- 对手银行所在地行政区划
            ,tx_cntpty_cert_type -- 交易对手证件类型
            ,tx_cntpty_cert_type_txt -- 交易对手证件类型中文描述
            ,tx_cntpty_cert_no -- 交易对手证件号码
            ,cd_typ -- 交易对手行号类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_oppnet_op(
            inr -- 主键inr
            ,gltyp -- 接口表
            ,glinr -- 接口表的inr
            ,gldate -- 记账日期
            ,trninr -- trn表的inr
            ,core_tran_flow_num -- 全局流水号
            ,biz_seq_num -- 系统流水号
            ,biz_seq_no -- 交易序号
            ,biz_ccy -- 币种
            ,biz_amt -- 金额
            ,pty_extkey -- 分录账号的客户号
            ,pty_name -- 分录账号的名称
            ,pty_acct_num -- 分录账号
            ,pty_acct_no -- 分录账号序号
            ,tran_type -- 借贷方向
            ,tx_cntpty_acct_num -- 交易对手账号
            ,tx_cntpty_name -- 交易对手名称
            ,cntpty_fin_inst_brac_cd -- 交易对手行号
            ,cntpty_fin_inst_brac_name -- 交易对手行名
            ,dist -- 对手银行所在地行政区划
            ,tx_cntpty_cert_type -- 交易对手证件类型
            ,tx_cntpty_cert_type_txt -- 交易对手证件类型中文描述
            ,tx_cntpty_cert_no -- 交易对手证件号码
            ,cd_typ -- 交易对手行号类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 主键inr
    ,o.gltyp -- 接口表
    ,o.glinr -- 接口表的inr
    ,o.gldate -- 记账日期
    ,o.trninr -- trn表的inr
    ,o.core_tran_flow_num -- 全局流水号
    ,o.biz_seq_num -- 系统流水号
    ,o.biz_seq_no -- 交易序号
    ,o.biz_ccy -- 币种
    ,o.biz_amt -- 金额
    ,o.pty_extkey -- 分录账号的客户号
    ,o.pty_name -- 分录账号的名称
    ,o.pty_acct_num -- 分录账号
    ,o.pty_acct_no -- 分录账号序号
    ,o.tran_type -- 借贷方向
    ,o.tx_cntpty_acct_num -- 交易对手账号
    ,o.tx_cntpty_name -- 交易对手名称
    ,o.cntpty_fin_inst_brac_cd -- 交易对手行号
    ,o.cntpty_fin_inst_brac_name -- 交易对手行名
    ,o.dist -- 对手银行所在地行政区划
    ,o.tx_cntpty_cert_type -- 交易对手证件类型
    ,o.tx_cntpty_cert_type_txt -- 交易对手证件类型中文描述
    ,o.tx_cntpty_cert_no -- 交易对手证件号码
    ,o.cd_typ -- 交易对手行号类型
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_oppnet_bk o
    left join ${iol_schema}.isbs_oppnet_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_oppnet_cl d
        on
            o.inr = d.inr
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.isbs_oppnet;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('isbs_oppnet') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.isbs_oppnet drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.isbs_oppnet add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.isbs_oppnet exchange partition p_${batch_date} with table ${iol_schema}.isbs_oppnet_cl;
alter table ${iol_schema}.isbs_oppnet exchange partition p_20991231 with table ${iol_schema}.isbs_oppnet_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_oppnet to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_oppnet_op purge;
drop table ${iol_schema}.isbs_oppnet_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_oppnet_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_oppnet',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
