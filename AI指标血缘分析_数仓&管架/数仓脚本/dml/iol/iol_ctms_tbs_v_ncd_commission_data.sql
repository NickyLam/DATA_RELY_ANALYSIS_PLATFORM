/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_v_ncd_commission_data
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
create table ${iol_schema}.ctms_tbs_v_ncd_commission_data_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_v_ncd_commission_data;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_ncd_commission_data_op purge;
drop table ${iol_schema}.ctms_tbs_v_ncd_commission_data_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_ncd_commission_data_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_ncd_commission_data where 0=1;

create table ${iol_schema}.ctms_tbs_v_ncd_commission_data_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_ncd_commission_data where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_ncd_commission_data_cl(
            ncd_commission_data_id -- ID
            ,aspclient_id -- 部门代号
            ,datasymbol_id -- 数据源ID
            ,serial_num -- 交易序号
            ,cus_number -- 机构号
            ,ncd_issue_serial -- 债券发行序号
            ,security_code -- 债券代码
            ,bidder -- 申购机构/投标机构
            ,bidder_seq -- 中标人序号
            ,partydetailaltid -- 交易接口
            ,bid_amount_cstp -- 持有量
            ,pf_amount_cstp -- 应缴款金额
            ,net_commission_amt_cstp -- 实缴款金额
            ,bid_amount -- 持有量
            ,pf_amount -- 应缴款金额
            ,net_commission_amt -- 实缴款金额
            ,modify_date -- 修改日期
            ,modify_user -- 修改人
            ,status -- 状态
            ,cstp_seq -- 序号
            ,commission_status -- 缴款状态
            ,ris_indctr -- 增发标识
            ,ris_tms -- 增发期数
            ,sort_no -- 增发序号
            ,lastmodified -- 最后修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_ncd_commission_data_op(
            ncd_commission_data_id -- ID
            ,aspclient_id -- 部门代号
            ,datasymbol_id -- 数据源ID
            ,serial_num -- 交易序号
            ,cus_number -- 机构号
            ,ncd_issue_serial -- 债券发行序号
            ,security_code -- 债券代码
            ,bidder -- 申购机构/投标机构
            ,bidder_seq -- 中标人序号
            ,partydetailaltid -- 交易接口
            ,bid_amount_cstp -- 持有量
            ,pf_amount_cstp -- 应缴款金额
            ,net_commission_amt_cstp -- 实缴款金额
            ,bid_amount -- 持有量
            ,pf_amount -- 应缴款金额
            ,net_commission_amt -- 实缴款金额
            ,modify_date -- 修改日期
            ,modify_user -- 修改人
            ,status -- 状态
            ,cstp_seq -- 序号
            ,commission_status -- 缴款状态
            ,ris_indctr -- 增发标识
            ,ris_tms -- 增发期数
            ,sort_no -- 增发序号
            ,lastmodified -- 最后修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ncd_commission_data_id, o.ncd_commission_data_id) as ncd_commission_data_id -- ID
    ,nvl(n.aspclient_id, o.aspclient_id) as aspclient_id -- 部门代号
    ,nvl(n.datasymbol_id, o.datasymbol_id) as datasymbol_id -- 数据源ID
    ,nvl(n.serial_num, o.serial_num) as serial_num -- 交易序号
    ,nvl(n.cus_number, o.cus_number) as cus_number -- 机构号
    ,nvl(n.ncd_issue_serial, o.ncd_issue_serial) as ncd_issue_serial -- 债券发行序号
    ,nvl(n.security_code, o.security_code) as security_code -- 债券代码
    ,nvl(n.bidder, o.bidder) as bidder -- 申购机构/投标机构
    ,nvl(n.bidder_seq, o.bidder_seq) as bidder_seq -- 中标人序号
    ,nvl(n.partydetailaltid, o.partydetailaltid) as partydetailaltid -- 交易接口
    ,nvl(n.bid_amount_cstp, o.bid_amount_cstp) as bid_amount_cstp -- 持有量
    ,nvl(n.pf_amount_cstp, o.pf_amount_cstp) as pf_amount_cstp -- 应缴款金额
    ,nvl(n.net_commission_amt_cstp, o.net_commission_amt_cstp) as net_commission_amt_cstp -- 实缴款金额
    ,nvl(n.bid_amount, o.bid_amount) as bid_amount -- 持有量
    ,nvl(n.pf_amount, o.pf_amount) as pf_amount -- 应缴款金额
    ,nvl(n.net_commission_amt, o.net_commission_amt) as net_commission_amt -- 实缴款金额
    ,nvl(n.modify_date, o.modify_date) as modify_date -- 修改日期
    ,nvl(n.modify_user, o.modify_user) as modify_user -- 修改人
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.cstp_seq, o.cstp_seq) as cstp_seq -- 序号
    ,nvl(n.commission_status, o.commission_status) as commission_status -- 缴款状态
    ,nvl(n.ris_indctr, o.ris_indctr) as ris_indctr -- 增发标识
    ,nvl(n.ris_tms, o.ris_tms) as ris_tms -- 增发期数
    ,nvl(n.sort_no, o.sort_no) as sort_no -- 增发序号
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 最后修改时间
    ,case when
            n.ncd_commission_data_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ncd_commission_data_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ncd_commission_data_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_tbs_v_ncd_commission_data_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_v_ncd_commission_data where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ncd_commission_data_id = n.ncd_commission_data_id
where (
        o.ncd_commission_data_id is null
    )
    or (
        n.ncd_commission_data_id is null
    )
    or (
        o.aspclient_id <> n.aspclient_id
        or o.datasymbol_id <> n.datasymbol_id
        or o.serial_num <> n.serial_num
        or o.cus_number <> n.cus_number
        or o.ncd_issue_serial <> n.ncd_issue_serial
        or o.security_code <> n.security_code
        or o.bidder <> n.bidder
        or o.bidder_seq <> n.bidder_seq
        or o.partydetailaltid <> n.partydetailaltid
        or o.bid_amount_cstp <> n.bid_amount_cstp
        or o.pf_amount_cstp <> n.pf_amount_cstp
        or o.net_commission_amt_cstp <> n.net_commission_amt_cstp
        or o.bid_amount <> n.bid_amount
        or o.pf_amount <> n.pf_amount
        or o.net_commission_amt <> n.net_commission_amt
        or o.modify_date <> n.modify_date
        or o.modify_user <> n.modify_user
        or o.status <> n.status
        or o.cstp_seq <> n.cstp_seq
        or o.commission_status <> n.commission_status
        or o.ris_indctr <> n.ris_indctr
        or o.ris_tms <> n.ris_tms
        or o.sort_no <> n.sort_no
        or o.lastmodified <> n.lastmodified
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_ncd_commission_data_cl(
            ncd_commission_data_id -- ID
            ,aspclient_id -- 部门代号
            ,datasymbol_id -- 数据源ID
            ,serial_num -- 交易序号
            ,cus_number -- 机构号
            ,ncd_issue_serial -- 债券发行序号
            ,security_code -- 债券代码
            ,bidder -- 申购机构/投标机构
            ,bidder_seq -- 中标人序号
            ,partydetailaltid -- 交易接口
            ,bid_amount_cstp -- 持有量
            ,pf_amount_cstp -- 应缴款金额
            ,net_commission_amt_cstp -- 实缴款金额
            ,bid_amount -- 持有量
            ,pf_amount -- 应缴款金额
            ,net_commission_amt -- 实缴款金额
            ,modify_date -- 修改日期
            ,modify_user -- 修改人
            ,status -- 状态
            ,cstp_seq -- 序号
            ,commission_status -- 缴款状态
            ,ris_indctr -- 增发标识
            ,ris_tms -- 增发期数
            ,sort_no -- 增发序号
            ,lastmodified -- 最后修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_ncd_commission_data_op(
            ncd_commission_data_id -- ID
            ,aspclient_id -- 部门代号
            ,datasymbol_id -- 数据源ID
            ,serial_num -- 交易序号
            ,cus_number -- 机构号
            ,ncd_issue_serial -- 债券发行序号
            ,security_code -- 债券代码
            ,bidder -- 申购机构/投标机构
            ,bidder_seq -- 中标人序号
            ,partydetailaltid -- 交易接口
            ,bid_amount_cstp -- 持有量
            ,pf_amount_cstp -- 应缴款金额
            ,net_commission_amt_cstp -- 实缴款金额
            ,bid_amount -- 持有量
            ,pf_amount -- 应缴款金额
            ,net_commission_amt -- 实缴款金额
            ,modify_date -- 修改日期
            ,modify_user -- 修改人
            ,status -- 状态
            ,cstp_seq -- 序号
            ,commission_status -- 缴款状态
            ,ris_indctr -- 增发标识
            ,ris_tms -- 增发期数
            ,sort_no -- 增发序号
            ,lastmodified -- 最后修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ncd_commission_data_id -- ID
    ,o.aspclient_id -- 部门代号
    ,o.datasymbol_id -- 数据源ID
    ,o.serial_num -- 交易序号
    ,o.cus_number -- 机构号
    ,o.ncd_issue_serial -- 债券发行序号
    ,o.security_code -- 债券代码
    ,o.bidder -- 申购机构/投标机构
    ,o.bidder_seq -- 中标人序号
    ,o.partydetailaltid -- 交易接口
    ,o.bid_amount_cstp -- 持有量
    ,o.pf_amount_cstp -- 应缴款金额
    ,o.net_commission_amt_cstp -- 实缴款金额
    ,o.bid_amount -- 持有量
    ,o.pf_amount -- 应缴款金额
    ,o.net_commission_amt -- 实缴款金额
    ,o.modify_date -- 修改日期
    ,o.modify_user -- 修改人
    ,o.status -- 状态
    ,o.cstp_seq -- 序号
    ,o.commission_status -- 缴款状态
    ,o.ris_indctr -- 增发标识
    ,o.ris_tms -- 增发期数
    ,o.sort_no -- 增发序号
    ,o.lastmodified -- 最后修改时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_tbs_v_ncd_commission_data_bk o
    left join ${iol_schema}.ctms_tbs_v_ncd_commission_data_op n
        on
            o.ncd_commission_data_id = n.ncd_commission_data_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_v_ncd_commission_data_cl d
        on
            o.ncd_commission_data_id = d.ncd_commission_data_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_tbs_v_ncd_commission_data;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_tbs_v_ncd_commission_data exchange partition p_19000101 with table ${iol_schema}.ctms_tbs_v_ncd_commission_data_cl;
alter table ${iol_schema}.ctms_tbs_v_ncd_commission_data exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_v_ncd_commission_data_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_v_ncd_commission_data to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_ncd_commission_data_op purge;
drop table ${iol_schema}.ctms_tbs_v_ncd_commission_data_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_v_ncd_commission_data_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_v_ncd_commission_data',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
