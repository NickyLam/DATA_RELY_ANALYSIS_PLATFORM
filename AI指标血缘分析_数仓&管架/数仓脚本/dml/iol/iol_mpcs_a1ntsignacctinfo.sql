/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a1ntsignacctinfo
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
create table ${iol_schema}.mpcs_a1ntsignacctinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a1ntsignacctinfo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1ntsignacctinfo_op purge;
drop table ${iol_schema}.mpcs_a1ntsignacctinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1ntsignacctinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1ntsignacctinfo where 0=1;

create table ${iol_schema}.mpcs_a1ntsignacctinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1ntsignacctinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1ntsignacctinfo_cl(
            mainseq -- 中台流水号
            ,projectcode -- 工程编码
            ,projectname -- 工程名称
            ,code -- 企业id
            ,qybh -- 企业编码
            ,name -- 企业名称
            ,fbqycode -- 发包企业id
            ,fbqyname -- 发包企业名称
            ,type -- 企业类型 0-建设单位 1-施工总包企业 5-专业分包企业 6-劳务分包企业
            ,specialaccount -- 专用账户号
            ,accountname -- 专用账户户名
            ,bankjointnumber -- 开户银行联行号
            ,optype -- 开户类型 1-新开户 2-变更开户
            ,opbalance -- 余额
            ,ophandler -- 开户经办人姓名
            ,ophandleridcard -- 开户经办人身份证号
            ,opcreatime -- 开户时间
            ,opremarks -- 开户备注信息
            ,destype -- 销户类型
            ,balance -- 结余资金
            ,deshandler -- 销户经办人姓名
            ,deshandleridcard -- 销户经办人身份证号
            ,transactionno -- 销户转账交易号
            ,destaccount -- 提取账户号
            ,destname -- 提取账户名称
            ,destorgancode -- 提取账户机构代码
            ,destbusicode -- 提取账户营业执照号
            ,descreatime -- 销户时间
            ,desremarks -- 销户备注信息
            ,status -- 账户状态 0-销户 1-开户
            ,sndstatus -- 上报状态 00-待上报 10-开户上报成功 11-开户上报失败 20-销户上报成功 21-销户上报失败 30-开户修改上报成功 31-开户修改上报失败
            ,updt -- 更新时间
            ,tlrno -- 柜员号
            ,brcno -- 交易机构
            ,oldspecialaccount -- 原转用账户号
            ,projno -- 行内项目号
            ,spectp -- 账户类型    4 基本账户    6 一般账户
            ,glacno -- 内部账户
            ,glacna -- 内部账户名称
            ,payacctno -- 他行基本户
            ,payacctname -- 他行基本户户名
            ,payacctbank -- 他行基本户开户行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1ntsignacctinfo_op(
            mainseq -- 中台流水号
            ,projectcode -- 工程编码
            ,projectname -- 工程名称
            ,code -- 企业id
            ,qybh -- 企业编码
            ,name -- 企业名称
            ,fbqycode -- 发包企业id
            ,fbqyname -- 发包企业名称
            ,type -- 企业类型 0-建设单位 1-施工总包企业 5-专业分包企业 6-劳务分包企业
            ,specialaccount -- 专用账户号
            ,accountname -- 专用账户户名
            ,bankjointnumber -- 开户银行联行号
            ,optype -- 开户类型 1-新开户 2-变更开户
            ,opbalance -- 余额
            ,ophandler -- 开户经办人姓名
            ,ophandleridcard -- 开户经办人身份证号
            ,opcreatime -- 开户时间
            ,opremarks -- 开户备注信息
            ,destype -- 销户类型
            ,balance -- 结余资金
            ,deshandler -- 销户经办人姓名
            ,deshandleridcard -- 销户经办人身份证号
            ,transactionno -- 销户转账交易号
            ,destaccount -- 提取账户号
            ,destname -- 提取账户名称
            ,destorgancode -- 提取账户机构代码
            ,destbusicode -- 提取账户营业执照号
            ,descreatime -- 销户时间
            ,desremarks -- 销户备注信息
            ,status -- 账户状态 0-销户 1-开户
            ,sndstatus -- 上报状态 00-待上报 10-开户上报成功 11-开户上报失败 20-销户上报成功 21-销户上报失败 30-开户修改上报成功 31-开户修改上报失败
            ,updt -- 更新时间
            ,tlrno -- 柜员号
            ,brcno -- 交易机构
            ,oldspecialaccount -- 原转用账户号
            ,projno -- 行内项目号
            ,spectp -- 账户类型    4 基本账户    6 一般账户
            ,glacno -- 内部账户
            ,glacna -- 内部账户名称
            ,payacctno -- 他行基本户
            ,payacctname -- 他行基本户户名
            ,payacctbank -- 他行基本户开户行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.mainseq, o.mainseq) as mainseq -- 中台流水号
    ,nvl(n.projectcode, o.projectcode) as projectcode -- 工程编码
    ,nvl(n.projectname, o.projectname) as projectname -- 工程名称
    ,nvl(n.code, o.code) as code -- 企业id
    ,nvl(n.qybh, o.qybh) as qybh -- 企业编码
    ,nvl(n.name, o.name) as name -- 企业名称
    ,nvl(n.fbqycode, o.fbqycode) as fbqycode -- 发包企业id
    ,nvl(n.fbqyname, o.fbqyname) as fbqyname -- 发包企业名称
    ,nvl(n.type, o.type) as type -- 企业类型 0-建设单位 1-施工总包企业 5-专业分包企业 6-劳务分包企业
    ,nvl(n.specialaccount, o.specialaccount) as specialaccount -- 专用账户号
    ,nvl(n.accountname, o.accountname) as accountname -- 专用账户户名
    ,nvl(n.bankjointnumber, o.bankjointnumber) as bankjointnumber -- 开户银行联行号
    ,nvl(n.optype, o.optype) as optype -- 开户类型 1-新开户 2-变更开户
    ,nvl(n.opbalance, o.opbalance) as opbalance -- 余额
    ,nvl(n.ophandler, o.ophandler) as ophandler -- 开户经办人姓名
    ,nvl(n.ophandleridcard, o.ophandleridcard) as ophandleridcard -- 开户经办人身份证号
    ,nvl(n.opcreatime, o.opcreatime) as opcreatime -- 开户时间
    ,nvl(n.opremarks, o.opremarks) as opremarks -- 开户备注信息
    ,nvl(n.destype, o.destype) as destype -- 销户类型
    ,nvl(n.balance, o.balance) as balance -- 结余资金
    ,nvl(n.deshandler, o.deshandler) as deshandler -- 销户经办人姓名
    ,nvl(n.deshandleridcard, o.deshandleridcard) as deshandleridcard -- 销户经办人身份证号
    ,nvl(n.transactionno, o.transactionno) as transactionno -- 销户转账交易号
    ,nvl(n.destaccount, o.destaccount) as destaccount -- 提取账户号
    ,nvl(n.destname, o.destname) as destname -- 提取账户名称
    ,nvl(n.destorgancode, o.destorgancode) as destorgancode -- 提取账户机构代码
    ,nvl(n.destbusicode, o.destbusicode) as destbusicode -- 提取账户营业执照号
    ,nvl(n.descreatime, o.descreatime) as descreatime -- 销户时间
    ,nvl(n.desremarks, o.desremarks) as desremarks -- 销户备注信息
    ,nvl(n.status, o.status) as status -- 账户状态 0-销户 1-开户
    ,nvl(n.sndstatus, o.sndstatus) as sndstatus -- 上报状态 00-待上报 10-开户上报成功 11-开户上报失败 20-销户上报成功 21-销户上报失败 30-开户修改上报成功 31-开户修改上报失败
    ,nvl(n.updt, o.updt) as updt -- 更新时间
    ,nvl(n.tlrno, o.tlrno) as tlrno -- 柜员号
    ,nvl(n.brcno, o.brcno) as brcno -- 交易机构
    ,nvl(n.oldspecialaccount, o.oldspecialaccount) as oldspecialaccount -- 原转用账户号
    ,nvl(n.projno, o.projno) as projno -- 行内项目号
    ,nvl(n.spectp, o.spectp) as spectp -- 账户类型    4 基本账户    6 一般账户
    ,nvl(n.glacno, o.glacno) as glacno -- 内部账户
    ,nvl(n.glacna, o.glacna) as glacna -- 内部账户名称
    ,nvl(n.payacctno, o.payacctno) as payacctno -- 他行基本户
    ,nvl(n.payacctname, o.payacctname) as payacctname -- 他行基本户户名
    ,nvl(n.payacctbank, o.payacctbank) as payacctbank -- 他行基本户开户行
    ,case when
            n.mainseq is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.mainseq is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.mainseq is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a1ntsignacctinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a1ntsignacctinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.mainseq = n.mainseq
where (
        o.mainseq is null
    )
    or (
        n.mainseq is null
    )
    or (
        o.projectcode <> n.projectcode
        or o.projectname <> n.projectname
        or o.code <> n.code
        or o.qybh <> n.qybh
        or o.name <> n.name
        or o.fbqycode <> n.fbqycode
        or o.fbqyname <> n.fbqyname
        or o.type <> n.type
        or o.specialaccount <> n.specialaccount
        or o.accountname <> n.accountname
        or o.bankjointnumber <> n.bankjointnumber
        or o.optype <> n.optype
        or o.opbalance <> n.opbalance
        or o.ophandler <> n.ophandler
        or o.ophandleridcard <> n.ophandleridcard
        or o.opcreatime <> n.opcreatime
        or o.opremarks <> n.opremarks
        or o.destype <> n.destype
        or o.balance <> n.balance
        or o.deshandler <> n.deshandler
        or o.deshandleridcard <> n.deshandleridcard
        or o.transactionno <> n.transactionno
        or o.destaccount <> n.destaccount
        or o.destname <> n.destname
        or o.destorgancode <> n.destorgancode
        or o.destbusicode <> n.destbusicode
        or o.descreatime <> n.descreatime
        or o.desremarks <> n.desremarks
        or o.status <> n.status
        or o.sndstatus <> n.sndstatus
        or o.updt <> n.updt
        or o.tlrno <> n.tlrno
        or o.brcno <> n.brcno
        or o.oldspecialaccount <> n.oldspecialaccount
        or o.projno <> n.projno
        or o.spectp <> n.spectp
        or o.glacno <> n.glacno
        or o.glacna <> n.glacna
        or o.payacctno <> n.payacctno
        or o.payacctname <> n.payacctname
        or o.payacctbank <> n.payacctbank
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1ntsignacctinfo_cl(
            mainseq -- 中台流水号
            ,projectcode -- 工程编码
            ,projectname -- 工程名称
            ,code -- 企业id
            ,qybh -- 企业编码
            ,name -- 企业名称
            ,fbqycode -- 发包企业id
            ,fbqyname -- 发包企业名称
            ,type -- 企业类型 0-建设单位 1-施工总包企业 5-专业分包企业 6-劳务分包企业
            ,specialaccount -- 专用账户号
            ,accountname -- 专用账户户名
            ,bankjointnumber -- 开户银行联行号
            ,optype -- 开户类型 1-新开户 2-变更开户
            ,opbalance -- 余额
            ,ophandler -- 开户经办人姓名
            ,ophandleridcard -- 开户经办人身份证号
            ,opcreatime -- 开户时间
            ,opremarks -- 开户备注信息
            ,destype -- 销户类型
            ,balance -- 结余资金
            ,deshandler -- 销户经办人姓名
            ,deshandleridcard -- 销户经办人身份证号
            ,transactionno -- 销户转账交易号
            ,destaccount -- 提取账户号
            ,destname -- 提取账户名称
            ,destorgancode -- 提取账户机构代码
            ,destbusicode -- 提取账户营业执照号
            ,descreatime -- 销户时间
            ,desremarks -- 销户备注信息
            ,status -- 账户状态 0-销户 1-开户
            ,sndstatus -- 上报状态 00-待上报 10-开户上报成功 11-开户上报失败 20-销户上报成功 21-销户上报失败 30-开户修改上报成功 31-开户修改上报失败
            ,updt -- 更新时间
            ,tlrno -- 柜员号
            ,brcno -- 交易机构
            ,oldspecialaccount -- 原转用账户号
            ,projno -- 行内项目号
            ,spectp -- 账户类型    4 基本账户    6 一般账户
            ,glacno -- 内部账户
            ,glacna -- 内部账户名称
            ,payacctno -- 他行基本户
            ,payacctname -- 他行基本户户名
            ,payacctbank -- 他行基本户开户行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1ntsignacctinfo_op(
            mainseq -- 中台流水号
            ,projectcode -- 工程编码
            ,projectname -- 工程名称
            ,code -- 企业id
            ,qybh -- 企业编码
            ,name -- 企业名称
            ,fbqycode -- 发包企业id
            ,fbqyname -- 发包企业名称
            ,type -- 企业类型 0-建设单位 1-施工总包企业 5-专业分包企业 6-劳务分包企业
            ,specialaccount -- 专用账户号
            ,accountname -- 专用账户户名
            ,bankjointnumber -- 开户银行联行号
            ,optype -- 开户类型 1-新开户 2-变更开户
            ,opbalance -- 余额
            ,ophandler -- 开户经办人姓名
            ,ophandleridcard -- 开户经办人身份证号
            ,opcreatime -- 开户时间
            ,opremarks -- 开户备注信息
            ,destype -- 销户类型
            ,balance -- 结余资金
            ,deshandler -- 销户经办人姓名
            ,deshandleridcard -- 销户经办人身份证号
            ,transactionno -- 销户转账交易号
            ,destaccount -- 提取账户号
            ,destname -- 提取账户名称
            ,destorgancode -- 提取账户机构代码
            ,destbusicode -- 提取账户营业执照号
            ,descreatime -- 销户时间
            ,desremarks -- 销户备注信息
            ,status -- 账户状态 0-销户 1-开户
            ,sndstatus -- 上报状态 00-待上报 10-开户上报成功 11-开户上报失败 20-销户上报成功 21-销户上报失败 30-开户修改上报成功 31-开户修改上报失败
            ,updt -- 更新时间
            ,tlrno -- 柜员号
            ,brcno -- 交易机构
            ,oldspecialaccount -- 原转用账户号
            ,projno -- 行内项目号
            ,spectp -- 账户类型    4 基本账户    6 一般账户
            ,glacno -- 内部账户
            ,glacna -- 内部账户名称
            ,payacctno -- 他行基本户
            ,payacctname -- 他行基本户户名
            ,payacctbank -- 他行基本户开户行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.mainseq -- 中台流水号
    ,o.projectcode -- 工程编码
    ,o.projectname -- 工程名称
    ,o.code -- 企业id
    ,o.qybh -- 企业编码
    ,o.name -- 企业名称
    ,o.fbqycode -- 发包企业id
    ,o.fbqyname -- 发包企业名称
    ,o.type -- 企业类型 0-建设单位 1-施工总包企业 5-专业分包企业 6-劳务分包企业
    ,o.specialaccount -- 专用账户号
    ,o.accountname -- 专用账户户名
    ,o.bankjointnumber -- 开户银行联行号
    ,o.optype -- 开户类型 1-新开户 2-变更开户
    ,o.opbalance -- 余额
    ,o.ophandler -- 开户经办人姓名
    ,o.ophandleridcard -- 开户经办人身份证号
    ,o.opcreatime -- 开户时间
    ,o.opremarks -- 开户备注信息
    ,o.destype -- 销户类型
    ,o.balance -- 结余资金
    ,o.deshandler -- 销户经办人姓名
    ,o.deshandleridcard -- 销户经办人身份证号
    ,o.transactionno -- 销户转账交易号
    ,o.destaccount -- 提取账户号
    ,o.destname -- 提取账户名称
    ,o.destorgancode -- 提取账户机构代码
    ,o.destbusicode -- 提取账户营业执照号
    ,o.descreatime -- 销户时间
    ,o.desremarks -- 销户备注信息
    ,o.status -- 账户状态 0-销户 1-开户
    ,o.sndstatus -- 上报状态 00-待上报 10-开户上报成功 11-开户上报失败 20-销户上报成功 21-销户上报失败 30-开户修改上报成功 31-开户修改上报失败
    ,o.updt -- 更新时间
    ,o.tlrno -- 柜员号
    ,o.brcno -- 交易机构
    ,o.oldspecialaccount -- 原转用账户号
    ,o.projno -- 行内项目号
    ,o.spectp -- 账户类型    4 基本账户    6 一般账户
    ,o.glacno -- 内部账户
    ,o.glacna -- 内部账户名称
    ,o.payacctno -- 他行基本户
    ,o.payacctname -- 他行基本户户名
    ,o.payacctbank -- 他行基本户开户行
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
from ${iol_schema}.mpcs_a1ntsignacctinfo_bk o
    left join ${iol_schema}.mpcs_a1ntsignacctinfo_op n
        on
            o.mainseq = n.mainseq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a1ntsignacctinfo_cl d
        on
            o.mainseq = d.mainseq
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a1ntsignacctinfo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a1ntsignacctinfo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a1ntsignacctinfo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a1ntsignacctinfo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a1ntsignacctinfo exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a1ntsignacctinfo_cl;
alter table ${iol_schema}.mpcs_a1ntsignacctinfo exchange partition p_20991231 with table ${iol_schema}.mpcs_a1ntsignacctinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a1ntsignacctinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1ntsignacctinfo_op purge;
drop table ${iol_schema}.mpcs_a1ntsignacctinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a1ntsignacctinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a1ntsignacctinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
