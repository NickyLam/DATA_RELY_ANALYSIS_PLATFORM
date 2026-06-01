/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a0jtpmisaddcrinfo
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
create table ${iol_schema}.mpcs_a0jtpmisaddcrinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a0jtpmisaddcrinfo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0jtpmisaddcrinfo_op purge;
drop table ${iol_schema}.mpcs_a0jtpmisaddcrinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0jtpmisaddcrinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0jtpmisaddcrinfo where 0=1;

create table ${iol_schema}.mpcs_a0jtpmisaddcrinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0jtpmisaddcrinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0jtpmisaddcrinfo_cl(
            mainseq -- 中台流水号
            ,transdt -- 交易日期
            ,status -- 交易状态 Z 初始状态 1 已应答
            ,trantype -- 交易类型
            ,bank_self_num -- 银行自身流水号
            ,biz_type_code -- 业务类型代码
            ,idtype_code -- 证件类型代码
            ,idcode -- 证件号码
            ,ctycode -- 国家/地区代码
            ,add_idcode -- 补充证件号码
            ,person_name -- 姓名
            ,biz_tx_chnl_code -- 务办理渠道代码
            ,txccy -- 币种
            ,cr_amt -- 存钞金额
            ,acct_no -- 个人外汇账户账号
            ,remark -- 备注
            ,refno -- 业务参号
            ,code -- 代码
            ,detail -- 错误详细信息
            ,cr_amt_date -- 当日已存入金额（折美元）
            ,cr_amt_year -- 当年已存入金额（折美元）
            ,src -- 发起节点代码
            ,des -- 接收节点代码
            ,sendtime -- 发送时间
            ,common_org_code -- 机构代码
            ,msgno -- 报文参考号
            ,transmessage -- 交易信息
            ,edit_reason_code -- 修改/撤销原因代码
            ,edit_remark -- 修改/撤销原因说明
            ,brcno -- 机构号
            ,tlrno -- 柜员
            ,srcseqno -- 柜面交易流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0jtpmisaddcrinfo_op(
            mainseq -- 中台流水号
            ,transdt -- 交易日期
            ,status -- 交易状态 Z 初始状态 1 已应答
            ,trantype -- 交易类型
            ,bank_self_num -- 银行自身流水号
            ,biz_type_code -- 业务类型代码
            ,idtype_code -- 证件类型代码
            ,idcode -- 证件号码
            ,ctycode -- 国家/地区代码
            ,add_idcode -- 补充证件号码
            ,person_name -- 姓名
            ,biz_tx_chnl_code -- 务办理渠道代码
            ,txccy -- 币种
            ,cr_amt -- 存钞金额
            ,acct_no -- 个人外汇账户账号
            ,remark -- 备注
            ,refno -- 业务参号
            ,code -- 代码
            ,detail -- 错误详细信息
            ,cr_amt_date -- 当日已存入金额（折美元）
            ,cr_amt_year -- 当年已存入金额（折美元）
            ,src -- 发起节点代码
            ,des -- 接收节点代码
            ,sendtime -- 发送时间
            ,common_org_code -- 机构代码
            ,msgno -- 报文参考号
            ,transmessage -- 交易信息
            ,edit_reason_code -- 修改/撤销原因代码
            ,edit_remark -- 修改/撤销原因说明
            ,brcno -- 机构号
            ,tlrno -- 柜员
            ,srcseqno -- 柜面交易流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.mainseq, o.mainseq) as mainseq -- 中台流水号
    ,nvl(n.transdt, o.transdt) as transdt -- 交易日期
    ,nvl(n.status, o.status) as status -- 交易状态 Z 初始状态 1 已应答
    ,nvl(n.trantype, o.trantype) as trantype -- 交易类型
    ,nvl(n.bank_self_num, o.bank_self_num) as bank_self_num -- 银行自身流水号
    ,nvl(n.biz_type_code, o.biz_type_code) as biz_type_code -- 业务类型代码
    ,nvl(n.idtype_code, o.idtype_code) as idtype_code -- 证件类型代码
    ,nvl(n.idcode, o.idcode) as idcode -- 证件号码
    ,nvl(n.ctycode, o.ctycode) as ctycode -- 国家/地区代码
    ,nvl(n.add_idcode, o.add_idcode) as add_idcode -- 补充证件号码
    ,nvl(n.person_name, o.person_name) as person_name -- 姓名
    ,nvl(n.biz_tx_chnl_code, o.biz_tx_chnl_code) as biz_tx_chnl_code -- 务办理渠道代码
    ,nvl(n.txccy, o.txccy) as txccy -- 币种
    ,nvl(n.cr_amt, o.cr_amt) as cr_amt -- 存钞金额
    ,nvl(n.acct_no, o.acct_no) as acct_no -- 个人外汇账户账号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.refno, o.refno) as refno -- 业务参号
    ,nvl(n.code, o.code) as code -- 代码
    ,nvl(n.detail, o.detail) as detail -- 错误详细信息
    ,nvl(n.cr_amt_date, o.cr_amt_date) as cr_amt_date -- 当日已存入金额（折美元）
    ,nvl(n.cr_amt_year, o.cr_amt_year) as cr_amt_year -- 当年已存入金额（折美元）
    ,nvl(n.src, o.src) as src -- 发起节点代码
    ,nvl(n.des, o.des) as des -- 接收节点代码
    ,nvl(n.sendtime, o.sendtime) as sendtime -- 发送时间
    ,nvl(n.common_org_code, o.common_org_code) as common_org_code -- 机构代码
    ,nvl(n.msgno, o.msgno) as msgno -- 报文参考号
    ,nvl(n.transmessage, o.transmessage) as transmessage -- 交易信息
    ,nvl(n.edit_reason_code, o.edit_reason_code) as edit_reason_code -- 修改/撤销原因代码
    ,nvl(n.edit_remark, o.edit_remark) as edit_remark -- 修改/撤销原因说明
    ,nvl(n.brcno, o.brcno) as brcno -- 机构号
    ,nvl(n.tlrno, o.tlrno) as tlrno -- 柜员
    ,nvl(n.srcseqno, o.srcseqno) as srcseqno -- 柜面交易流水
    ,case when
            n.mainseq is null
            and n.transdt is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.mainseq is null
            and n.transdt is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.mainseq is null
            and n.transdt is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a0jtpmisaddcrinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a0jtpmisaddcrinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.mainseq = n.mainseq
            and o.transdt = n.transdt
where (
        o.mainseq is null
        and o.transdt is null
    )
    or (
        n.mainseq is null
        and n.transdt is null
    )
    or (
        o.status <> n.status
        or o.trantype <> n.trantype
        or o.bank_self_num <> n.bank_self_num
        or o.biz_type_code <> n.biz_type_code
        or o.idtype_code <> n.idtype_code
        or o.idcode <> n.idcode
        or o.ctycode <> n.ctycode
        or o.add_idcode <> n.add_idcode
        or o.person_name <> n.person_name
        or o.biz_tx_chnl_code <> n.biz_tx_chnl_code
        or o.txccy <> n.txccy
        or o.cr_amt <> n.cr_amt
        or o.acct_no <> n.acct_no
        or o.remark <> n.remark
        or o.refno <> n.refno
        or o.code <> n.code
        or o.detail <> n.detail
        or o.cr_amt_date <> n.cr_amt_date
        or o.cr_amt_year <> n.cr_amt_year
        or o.src <> n.src
        or o.des <> n.des
        or o.sendtime <> n.sendtime
        or o.common_org_code <> n.common_org_code
        or o.msgno <> n.msgno
        or o.transmessage <> n.transmessage
        or o.edit_reason_code <> n.edit_reason_code
        or o.edit_remark <> n.edit_remark
        or o.brcno <> n.brcno
        or o.tlrno <> n.tlrno
        or o.srcseqno <> n.srcseqno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0jtpmisaddcrinfo_cl(
            mainseq -- 中台流水号
            ,transdt -- 交易日期
            ,status -- 交易状态 Z 初始状态 1 已应答
            ,trantype -- 交易类型
            ,bank_self_num -- 银行自身流水号
            ,biz_type_code -- 业务类型代码
            ,idtype_code -- 证件类型代码
            ,idcode -- 证件号码
            ,ctycode -- 国家/地区代码
            ,add_idcode -- 补充证件号码
            ,person_name -- 姓名
            ,biz_tx_chnl_code -- 务办理渠道代码
            ,txccy -- 币种
            ,cr_amt -- 存钞金额
            ,acct_no -- 个人外汇账户账号
            ,remark -- 备注
            ,refno -- 业务参号
            ,code -- 代码
            ,detail -- 错误详细信息
            ,cr_amt_date -- 当日已存入金额（折美元）
            ,cr_amt_year -- 当年已存入金额（折美元）
            ,src -- 发起节点代码
            ,des -- 接收节点代码
            ,sendtime -- 发送时间
            ,common_org_code -- 机构代码
            ,msgno -- 报文参考号
            ,transmessage -- 交易信息
            ,edit_reason_code -- 修改/撤销原因代码
            ,edit_remark -- 修改/撤销原因说明
            ,brcno -- 机构号
            ,tlrno -- 柜员
            ,srcseqno -- 柜面交易流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0jtpmisaddcrinfo_op(
            mainseq -- 中台流水号
            ,transdt -- 交易日期
            ,status -- 交易状态 Z 初始状态 1 已应答
            ,trantype -- 交易类型
            ,bank_self_num -- 银行自身流水号
            ,biz_type_code -- 业务类型代码
            ,idtype_code -- 证件类型代码
            ,idcode -- 证件号码
            ,ctycode -- 国家/地区代码
            ,add_idcode -- 补充证件号码
            ,person_name -- 姓名
            ,biz_tx_chnl_code -- 务办理渠道代码
            ,txccy -- 币种
            ,cr_amt -- 存钞金额
            ,acct_no -- 个人外汇账户账号
            ,remark -- 备注
            ,refno -- 业务参号
            ,code -- 代码
            ,detail -- 错误详细信息
            ,cr_amt_date -- 当日已存入金额（折美元）
            ,cr_amt_year -- 当年已存入金额（折美元）
            ,src -- 发起节点代码
            ,des -- 接收节点代码
            ,sendtime -- 发送时间
            ,common_org_code -- 机构代码
            ,msgno -- 报文参考号
            ,transmessage -- 交易信息
            ,edit_reason_code -- 修改/撤销原因代码
            ,edit_remark -- 修改/撤销原因说明
            ,brcno -- 机构号
            ,tlrno -- 柜员
            ,srcseqno -- 柜面交易流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.mainseq -- 中台流水号
    ,o.transdt -- 交易日期
    ,o.status -- 交易状态 Z 初始状态 1 已应答
    ,o.trantype -- 交易类型
    ,o.bank_self_num -- 银行自身流水号
    ,o.biz_type_code -- 业务类型代码
    ,o.idtype_code -- 证件类型代码
    ,o.idcode -- 证件号码
    ,o.ctycode -- 国家/地区代码
    ,o.add_idcode -- 补充证件号码
    ,o.person_name -- 姓名
    ,o.biz_tx_chnl_code -- 务办理渠道代码
    ,o.txccy -- 币种
    ,o.cr_amt -- 存钞金额
    ,o.acct_no -- 个人外汇账户账号
    ,o.remark -- 备注
    ,o.refno -- 业务参号
    ,o.code -- 代码
    ,o.detail -- 错误详细信息
    ,o.cr_amt_date -- 当日已存入金额（折美元）
    ,o.cr_amt_year -- 当年已存入金额（折美元）
    ,o.src -- 发起节点代码
    ,o.des -- 接收节点代码
    ,o.sendtime -- 发送时间
    ,o.common_org_code -- 机构代码
    ,o.msgno -- 报文参考号
    ,o.transmessage -- 交易信息
    ,o.edit_reason_code -- 修改/撤销原因代码
    ,o.edit_remark -- 修改/撤销原因说明
    ,o.brcno -- 机构号
    ,o.tlrno -- 柜员
    ,o.srcseqno -- 柜面交易流水
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
from ${iol_schema}.mpcs_a0jtpmisaddcrinfo_bk o
    left join ${iol_schema}.mpcs_a0jtpmisaddcrinfo_op n
        on
            o.mainseq = n.mainseq
            and o.transdt = n.transdt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a0jtpmisaddcrinfo_cl d
        on
            o.mainseq = d.mainseq
            and o.transdt = d.transdt
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a0jtpmisaddcrinfo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a0jtpmisaddcrinfo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a0jtpmisaddcrinfo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a0jtpmisaddcrinfo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a0jtpmisaddcrinfo exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a0jtpmisaddcrinfo_cl;
alter table ${iol_schema}.mpcs_a0jtpmisaddcrinfo exchange partition p_20991231 with table ${iol_schema}.mpcs_a0jtpmisaddcrinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a0jtpmisaddcrinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0jtpmisaddcrinfo_op purge;
drop table ${iol_schema}.mpcs_a0jtpmisaddcrinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a0jtpmisaddcrinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a0jtpmisaddcrinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
