/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a0jtpmisaddtqinfo
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
create table ${iol_schema}.mpcs_a0jtpmisaddtqinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a0jtpmisaddtqinfo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0jtpmisaddtqinfo_op purge;
drop table ${iol_schema}.mpcs_a0jtpmisaddtqinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0jtpmisaddtqinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0jtpmisaddtqinfo where 0=1;

create table ${iol_schema}.mpcs_a0jtpmisaddtqinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0jtpmisaddtqinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0jtpmisaddtqinfo_cl(
            mainseq -- 中台流水号
            ,transdt -- 交易日期
            ,trantype -- 交易类型 1-提钞 2-提钞补录
            ,biz_type_code -- 业务类型 02-账户提钞/06-外币兑换外币提取/08-其他提钞
            ,bank_self_num -- 银行自身流水号
            ,idtype_code -- 证件类型代码
            ,idcode -- 证件号码
            ,person_name -- 姓名
            ,ctycode -- 国家/地区代码
            ,add_idcode -- 补充证件号码
            ,biz_tx_chnl_code -- 业务办理渠道代码 12-柜台渠道（接口模式） 23-自助终端 42-特许兑换机构（接口模式柜台业务） 52-非银行金融机构（接口模式柜台业务）
            ,txccy -- 币种
            ,zq_amt -- 金额
            ,acct_no -- 个人外汇账户账号
            ,biz_tx_time -- 业务办理时间
            ,remark -- 备注
            ,rein_reason_code -- 补录原因代码
            ,rein_remark -- 补录说明
            ,status -- 交易状态 Z 初始状态 0-失败 1-成功 C-已撤销
            ,refno -- 业务参号
            ,code -- 返回码
            ,detail -- 返回信息
            ,tq_amt_date -- 当日已提取金额（折美元）
            ,tq_amt_year -- 当年已提取金额（折美元）
            ,src -- 发起节点代码
            ,des -- 接收节点代码
            ,sendtime -- 发送时间
            ,common_org_code -- 机构代码
            ,msgno -- 报文参考号
            ,brcno -- 交易机构
            ,tlrno -- 交易柜员
            ,srcsysid -- 渠道
            ,srcseqno -- 渠道流水号
            ,uptm -- 更新时间
            ,upbrcno -- 更新机构
            ,uptlrno -- 更新柜员
            ,uptype -- 更新类型 0-查询 1-修改 2-撤销
            ,upreason_code -- 更新原因代码
            ,upremark -- 更新原因
            ,uprefno -- 更新业务参考号
            ,upbank_self_num -- 更新银行自身流水号
            ,glob_seq_num -- 全局流水号
            ,unique_seq_num -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0jtpmisaddtqinfo_op(
            mainseq -- 中台流水号
            ,transdt -- 交易日期
            ,trantype -- 交易类型 1-提钞 2-提钞补录
            ,biz_type_code -- 业务类型 02-账户提钞/06-外币兑换外币提取/08-其他提钞
            ,bank_self_num -- 银行自身流水号
            ,idtype_code -- 证件类型代码
            ,idcode -- 证件号码
            ,person_name -- 姓名
            ,ctycode -- 国家/地区代码
            ,add_idcode -- 补充证件号码
            ,biz_tx_chnl_code -- 业务办理渠道代码 12-柜台渠道（接口模式） 23-自助终端 42-特许兑换机构（接口模式柜台业务） 52-非银行金融机构（接口模式柜台业务）
            ,txccy -- 币种
            ,zq_amt -- 金额
            ,acct_no -- 个人外汇账户账号
            ,biz_tx_time -- 业务办理时间
            ,remark -- 备注
            ,rein_reason_code -- 补录原因代码
            ,rein_remark -- 补录说明
            ,status -- 交易状态 Z 初始状态 0-失败 1-成功 C-已撤销
            ,refno -- 业务参号
            ,code -- 返回码
            ,detail -- 返回信息
            ,tq_amt_date -- 当日已提取金额（折美元）
            ,tq_amt_year -- 当年已提取金额（折美元）
            ,src -- 发起节点代码
            ,des -- 接收节点代码
            ,sendtime -- 发送时间
            ,common_org_code -- 机构代码
            ,msgno -- 报文参考号
            ,brcno -- 交易机构
            ,tlrno -- 交易柜员
            ,srcsysid -- 渠道
            ,srcseqno -- 渠道流水号
            ,uptm -- 更新时间
            ,upbrcno -- 更新机构
            ,uptlrno -- 更新柜员
            ,uptype -- 更新类型 0-查询 1-修改 2-撤销
            ,upreason_code -- 更新原因代码
            ,upremark -- 更新原因
            ,uprefno -- 更新业务参考号
            ,upbank_self_num -- 更新银行自身流水号
            ,glob_seq_num -- 全局流水号
            ,unique_seq_num -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.mainseq, o.mainseq) as mainseq -- 中台流水号
    ,nvl(n.transdt, o.transdt) as transdt -- 交易日期
    ,nvl(n.trantype, o.trantype) as trantype -- 交易类型 1-提钞 2-提钞补录
    ,nvl(n.biz_type_code, o.biz_type_code) as biz_type_code -- 业务类型 02-账户提钞/06-外币兑换外币提取/08-其他提钞
    ,nvl(n.bank_self_num, o.bank_self_num) as bank_self_num -- 银行自身流水号
    ,nvl(n.idtype_code, o.idtype_code) as idtype_code -- 证件类型代码
    ,nvl(n.idcode, o.idcode) as idcode -- 证件号码
    ,nvl(n.person_name, o.person_name) as person_name -- 姓名
    ,nvl(n.ctycode, o.ctycode) as ctycode -- 国家/地区代码
    ,nvl(n.add_idcode, o.add_idcode) as add_idcode -- 补充证件号码
    ,nvl(n.biz_tx_chnl_code, o.biz_tx_chnl_code) as biz_tx_chnl_code -- 业务办理渠道代码 12-柜台渠道（接口模式） 23-自助终端 42-特许兑换机构（接口模式柜台业务） 52-非银行金融机构（接口模式柜台业务）
    ,nvl(n.txccy, o.txccy) as txccy -- 币种
    ,nvl(n.zq_amt, o.zq_amt) as zq_amt -- 金额
    ,nvl(n.acct_no, o.acct_no) as acct_no -- 个人外汇账户账号
    ,nvl(n.biz_tx_time, o.biz_tx_time) as biz_tx_time -- 业务办理时间
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.rein_reason_code, o.rein_reason_code) as rein_reason_code -- 补录原因代码
    ,nvl(n.rein_remark, o.rein_remark) as rein_remark -- 补录说明
    ,nvl(n.status, o.status) as status -- 交易状态 Z 初始状态 0-失败 1-成功 C-已撤销
    ,nvl(n.refno, o.refno) as refno -- 业务参号
    ,nvl(n.code, o.code) as code -- 返回码
    ,nvl(n.detail, o.detail) as detail -- 返回信息
    ,nvl(n.tq_amt_date, o.tq_amt_date) as tq_amt_date -- 当日已提取金额（折美元）
    ,nvl(n.tq_amt_year, o.tq_amt_year) as tq_amt_year -- 当年已提取金额（折美元）
    ,nvl(n.src, o.src) as src -- 发起节点代码
    ,nvl(n.des, o.des) as des -- 接收节点代码
    ,nvl(n.sendtime, o.sendtime) as sendtime -- 发送时间
    ,nvl(n.common_org_code, o.common_org_code) as common_org_code -- 机构代码
    ,nvl(n.msgno, o.msgno) as msgno -- 报文参考号
    ,nvl(n.brcno, o.brcno) as brcno -- 交易机构
    ,nvl(n.tlrno, o.tlrno) as tlrno -- 交易柜员
    ,nvl(n.srcsysid, o.srcsysid) as srcsysid -- 渠道
    ,nvl(n.srcseqno, o.srcseqno) as srcseqno -- 渠道流水号
    ,nvl(n.uptm, o.uptm) as uptm -- 更新时间
    ,nvl(n.upbrcno, o.upbrcno) as upbrcno -- 更新机构
    ,nvl(n.uptlrno, o.uptlrno) as uptlrno -- 更新柜员
    ,nvl(n.uptype, o.uptype) as uptype -- 更新类型 0-查询 1-修改 2-撤销
    ,nvl(n.upreason_code, o.upreason_code) as upreason_code -- 更新原因代码
    ,nvl(n.upremark, o.upremark) as upremark -- 更新原因
    ,nvl(n.uprefno, o.uprefno) as uprefno -- 更新业务参考号
    ,nvl(n.upbank_self_num, o.upbank_self_num) as upbank_self_num -- 更新银行自身流水号
    ,nvl(n.glob_seq_num, o.glob_seq_num) as glob_seq_num -- 全局流水号
    ,nvl(n.unique_seq_num, o.unique_seq_num) as unique_seq_num -- 业务流水号
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
from (select * from ${iol_schema}.mpcs_a0jtpmisaddtqinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a0jtpmisaddtqinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        o.trantype <> n.trantype
        or o.biz_type_code <> n.biz_type_code
        or o.bank_self_num <> n.bank_self_num
        or o.idtype_code <> n.idtype_code
        or o.idcode <> n.idcode
        or o.person_name <> n.person_name
        or o.ctycode <> n.ctycode
        or o.add_idcode <> n.add_idcode
        or o.biz_tx_chnl_code <> n.biz_tx_chnl_code
        or o.txccy <> n.txccy
        or o.zq_amt <> n.zq_amt
        or o.acct_no <> n.acct_no
        or o.biz_tx_time <> n.biz_tx_time
        or o.remark <> n.remark
        or o.rein_reason_code <> n.rein_reason_code
        or o.rein_remark <> n.rein_remark
        or o.status <> n.status
        or o.refno <> n.refno
        or o.code <> n.code
        or o.detail <> n.detail
        or o.tq_amt_date <> n.tq_amt_date
        or o.tq_amt_year <> n.tq_amt_year
        or o.src <> n.src
        or o.des <> n.des
        or o.sendtime <> n.sendtime
        or o.common_org_code <> n.common_org_code
        or o.msgno <> n.msgno
        or o.brcno <> n.brcno
        or o.tlrno <> n.tlrno
        or o.srcsysid <> n.srcsysid
        or o.srcseqno <> n.srcseqno
        or o.uptm <> n.uptm
        or o.upbrcno <> n.upbrcno
        or o.uptlrno <> n.uptlrno
        or o.uptype <> n.uptype
        or o.upreason_code <> n.upreason_code
        or o.upremark <> n.upremark
        or o.uprefno <> n.uprefno
        or o.upbank_self_num <> n.upbank_self_num
        or o.glob_seq_num <> n.glob_seq_num
        or o.unique_seq_num <> n.unique_seq_num
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0jtpmisaddtqinfo_cl(
            mainseq -- 中台流水号
            ,transdt -- 交易日期
            ,trantype -- 交易类型 1-提钞 2-提钞补录
            ,biz_type_code -- 业务类型 02-账户提钞/06-外币兑换外币提取/08-其他提钞
            ,bank_self_num -- 银行自身流水号
            ,idtype_code -- 证件类型代码
            ,idcode -- 证件号码
            ,person_name -- 姓名
            ,ctycode -- 国家/地区代码
            ,add_idcode -- 补充证件号码
            ,biz_tx_chnl_code -- 业务办理渠道代码 12-柜台渠道（接口模式） 23-自助终端 42-特许兑换机构（接口模式柜台业务） 52-非银行金融机构（接口模式柜台业务）
            ,txccy -- 币种
            ,zq_amt -- 金额
            ,acct_no -- 个人外汇账户账号
            ,biz_tx_time -- 业务办理时间
            ,remark -- 备注
            ,rein_reason_code -- 补录原因代码
            ,rein_remark -- 补录说明
            ,status -- 交易状态 Z 初始状态 0-失败 1-成功 C-已撤销
            ,refno -- 业务参号
            ,code -- 返回码
            ,detail -- 返回信息
            ,tq_amt_date -- 当日已提取金额（折美元）
            ,tq_amt_year -- 当年已提取金额（折美元）
            ,src -- 发起节点代码
            ,des -- 接收节点代码
            ,sendtime -- 发送时间
            ,common_org_code -- 机构代码
            ,msgno -- 报文参考号
            ,brcno -- 交易机构
            ,tlrno -- 交易柜员
            ,srcsysid -- 渠道
            ,srcseqno -- 渠道流水号
            ,uptm -- 更新时间
            ,upbrcno -- 更新机构
            ,uptlrno -- 更新柜员
            ,uptype -- 更新类型 0-查询 1-修改 2-撤销
            ,upreason_code -- 更新原因代码
            ,upremark -- 更新原因
            ,uprefno -- 更新业务参考号
            ,upbank_self_num -- 更新银行自身流水号
            ,glob_seq_num -- 全局流水号
            ,unique_seq_num -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0jtpmisaddtqinfo_op(
            mainseq -- 中台流水号
            ,transdt -- 交易日期
            ,trantype -- 交易类型 1-提钞 2-提钞补录
            ,biz_type_code -- 业务类型 02-账户提钞/06-外币兑换外币提取/08-其他提钞
            ,bank_self_num -- 银行自身流水号
            ,idtype_code -- 证件类型代码
            ,idcode -- 证件号码
            ,person_name -- 姓名
            ,ctycode -- 国家/地区代码
            ,add_idcode -- 补充证件号码
            ,biz_tx_chnl_code -- 业务办理渠道代码 12-柜台渠道（接口模式） 23-自助终端 42-特许兑换机构（接口模式柜台业务） 52-非银行金融机构（接口模式柜台业务）
            ,txccy -- 币种
            ,zq_amt -- 金额
            ,acct_no -- 个人外汇账户账号
            ,biz_tx_time -- 业务办理时间
            ,remark -- 备注
            ,rein_reason_code -- 补录原因代码
            ,rein_remark -- 补录说明
            ,status -- 交易状态 Z 初始状态 0-失败 1-成功 C-已撤销
            ,refno -- 业务参号
            ,code -- 返回码
            ,detail -- 返回信息
            ,tq_amt_date -- 当日已提取金额（折美元）
            ,tq_amt_year -- 当年已提取金额（折美元）
            ,src -- 发起节点代码
            ,des -- 接收节点代码
            ,sendtime -- 发送时间
            ,common_org_code -- 机构代码
            ,msgno -- 报文参考号
            ,brcno -- 交易机构
            ,tlrno -- 交易柜员
            ,srcsysid -- 渠道
            ,srcseqno -- 渠道流水号
            ,uptm -- 更新时间
            ,upbrcno -- 更新机构
            ,uptlrno -- 更新柜员
            ,uptype -- 更新类型 0-查询 1-修改 2-撤销
            ,upreason_code -- 更新原因代码
            ,upremark -- 更新原因
            ,uprefno -- 更新业务参考号
            ,upbank_self_num -- 更新银行自身流水号
            ,glob_seq_num -- 全局流水号
            ,unique_seq_num -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.mainseq -- 中台流水号
    ,o.transdt -- 交易日期
    ,o.trantype -- 交易类型 1-提钞 2-提钞补录
    ,o.biz_type_code -- 业务类型 02-账户提钞/06-外币兑换外币提取/08-其他提钞
    ,o.bank_self_num -- 银行自身流水号
    ,o.idtype_code -- 证件类型代码
    ,o.idcode -- 证件号码
    ,o.person_name -- 姓名
    ,o.ctycode -- 国家/地区代码
    ,o.add_idcode -- 补充证件号码
    ,o.biz_tx_chnl_code -- 业务办理渠道代码 12-柜台渠道（接口模式） 23-自助终端 42-特许兑换机构（接口模式柜台业务） 52-非银行金融机构（接口模式柜台业务）
    ,o.txccy -- 币种
    ,o.zq_amt -- 金额
    ,o.acct_no -- 个人外汇账户账号
    ,o.biz_tx_time -- 业务办理时间
    ,o.remark -- 备注
    ,o.rein_reason_code -- 补录原因代码
    ,o.rein_remark -- 补录说明
    ,o.status -- 交易状态 Z 初始状态 0-失败 1-成功 C-已撤销
    ,o.refno -- 业务参号
    ,o.code -- 返回码
    ,o.detail -- 返回信息
    ,o.tq_amt_date -- 当日已提取金额（折美元）
    ,o.tq_amt_year -- 当年已提取金额（折美元）
    ,o.src -- 发起节点代码
    ,o.des -- 接收节点代码
    ,o.sendtime -- 发送时间
    ,o.common_org_code -- 机构代码
    ,o.msgno -- 报文参考号
    ,o.brcno -- 交易机构
    ,o.tlrno -- 交易柜员
    ,o.srcsysid -- 渠道
    ,o.srcseqno -- 渠道流水号
    ,o.uptm -- 更新时间
    ,o.upbrcno -- 更新机构
    ,o.uptlrno -- 更新柜员
    ,o.uptype -- 更新类型 0-查询 1-修改 2-撤销
    ,o.upreason_code -- 更新原因代码
    ,o.upremark -- 更新原因
    ,o.uprefno -- 更新业务参考号
    ,o.upbank_self_num -- 更新银行自身流水号
    ,o.glob_seq_num -- 全局流水号
    ,o.unique_seq_num -- 业务流水号
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
from ${iol_schema}.mpcs_a0jtpmisaddtqinfo_bk o
    left join ${iol_schema}.mpcs_a0jtpmisaddtqinfo_op n
        on
            o.mainseq = n.mainseq
            and o.transdt = n.transdt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a0jtpmisaddtqinfo_cl d
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
--truncate table ${iol_schema}.mpcs_a0jtpmisaddtqinfo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a0jtpmisaddtqinfo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a0jtpmisaddtqinfo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a0jtpmisaddtqinfo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a0jtpmisaddtqinfo exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a0jtpmisaddtqinfo_cl;
alter table ${iol_schema}.mpcs_a0jtpmisaddtqinfo exchange partition p_20991231 with table ${iol_schema}.mpcs_a0jtpmisaddtqinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a0jtpmisaddtqinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0jtpmisaddtqinfo_op purge;
drop table ${iol_schema}.mpcs_a0jtpmisaddtqinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a0jtpmisaddtqinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a0jtpmisaddtqinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
