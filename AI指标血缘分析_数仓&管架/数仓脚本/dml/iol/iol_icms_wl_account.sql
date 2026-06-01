/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wl_account
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
create table ${iol_schema}.icms_wl_account_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_wl_account
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wl_account_op purge;
drop table ${iol_schema}.icms_wl_account_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wl_account_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wl_account where 0=1;

create table ${iol_schema}.icms_wl_account_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wl_account where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wl_account_cl(
            serialno -- 卡变更流水号
            ,enddate -- 分类失效日期
            ,createuser -- 创建用户
            ,openbankno -- 开户行号
            ,fncintcode -- 金融机构编码
            ,openbranch -- 开户网点
            ,migtflag -- 
            ,organcode -- 内部机构编号
            ,cardtype -- 银行卡卡种
            ,bankpayid -- 绑定银行支付ID
            ,updatetime -- 更新时间
            ,accountname -- 账户名称
            ,accounttype -- 账户类型（0-一般户/借记卡，1-基本户/内部户，2-对公保证金户，3-对公活期账户，4-电子账户，9-虚拟账户）
            ,openbank -- 开户行名
            ,updateuser -- 更新用户
            ,accountno -- 账户编号
            ,acctownid -- 账号所属ID(客户编号或者合作机构编号)
            ,startdate -- 分类生效日期
            ,accountflg -- 账户状态，0可用（默认），1不可用
            ,createtime -- 创建时间
            ,assetstype -- 资产方账户类型（1-资金方账户2-资产方账户,3-个人账户）
            ,bindidno -- 绑定身份证号
            ,bindcardno -- 绑定银行卡号
            ,accountdesc -- 账户描述
            ,openbranchname -- 开户网点名称
            ,repaysignid -- 扣款签约ID
            ,preserialno -- 记录上次卡变更记录流水号
            ,openname -- 开户名称（人或公司名）
            ,otherbankflag -- 他行卡标识(0本行，1他行)
            ,accountnum -- 账号
            ,bindphone -- 绑定手机号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wl_account_op(
            serialno -- 卡变更流水号
            ,enddate -- 分类失效日期
            ,createuser -- 创建用户
            ,openbankno -- 开户行号
            ,fncintcode -- 金融机构编码
            ,openbranch -- 开户网点
            ,migtflag -- 
            ,organcode -- 内部机构编号
            ,cardtype -- 银行卡卡种
            ,bankpayid -- 绑定银行支付ID
            ,updatetime -- 更新时间
            ,accountname -- 账户名称
            ,accounttype -- 账户类型（0-一般户/借记卡，1-基本户/内部户，2-对公保证金户，3-对公活期账户，4-电子账户，9-虚拟账户）
            ,openbank -- 开户行名
            ,updateuser -- 更新用户
            ,accountno -- 账户编号
            ,acctownid -- 账号所属ID(客户编号或者合作机构编号)
            ,startdate -- 分类生效日期
            ,accountflg -- 账户状态，0可用（默认），1不可用
            ,createtime -- 创建时间
            ,assetstype -- 资产方账户类型（1-资金方账户2-资产方账户,3-个人账户）
            ,bindidno -- 绑定身份证号
            ,bindcardno -- 绑定银行卡号
            ,accountdesc -- 账户描述
            ,openbranchname -- 开户网点名称
            ,repaysignid -- 扣款签约ID
            ,preserialno -- 记录上次卡变更记录流水号
            ,openname -- 开户名称（人或公司名）
            ,otherbankflag -- 他行卡标识(0本行，1他行)
            ,accountnum -- 账号
            ,bindphone -- 绑定手机号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 卡变更流水号
    ,nvl(n.enddate, o.enddate) as enddate -- 分类失效日期
    ,nvl(n.createuser, o.createuser) as createuser -- 创建用户
    ,nvl(n.openbankno, o.openbankno) as openbankno -- 开户行号
    ,nvl(n.fncintcode, o.fncintcode) as fncintcode -- 金融机构编码
    ,nvl(n.openbranch, o.openbranch) as openbranch -- 开户网点
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.organcode, o.organcode) as organcode -- 内部机构编号
    ,nvl(n.cardtype, o.cardtype) as cardtype -- 银行卡卡种
    ,nvl(n.bankpayid, o.bankpayid) as bankpayid -- 绑定银行支付ID
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 更新时间
    ,nvl(n.accountname, o.accountname) as accountname -- 账户名称
    ,nvl(n.accounttype, o.accounttype) as accounttype -- 账户类型（0-一般户/借记卡，1-基本户/内部户，2-对公保证金户，3-对公活期账户，4-电子账户，9-虚拟账户）
    ,nvl(n.openbank, o.openbank) as openbank -- 开户行名
    ,nvl(n.updateuser, o.updateuser) as updateuser -- 更新用户
    ,nvl(n.accountno, o.accountno) as accountno -- 账户编号
    ,nvl(n.acctownid, o.acctownid) as acctownid -- 账号所属ID(客户编号或者合作机构编号)
    ,nvl(n.startdate, o.startdate) as startdate -- 分类生效日期
    ,nvl(n.accountflg, o.accountflg) as accountflg -- 账户状态，0可用（默认），1不可用
    ,nvl(n.createtime, o.createtime) as createtime -- 创建时间
    ,nvl(n.assetstype, o.assetstype) as assetstype -- 资产方账户类型（1-资金方账户2-资产方账户,3-个人账户）
    ,nvl(n.bindidno, o.bindidno) as bindidno -- 绑定身份证号
    ,nvl(n.bindcardno, o.bindcardno) as bindcardno -- 绑定银行卡号
    ,nvl(n.accountdesc, o.accountdesc) as accountdesc -- 账户描述
    ,nvl(n.openbranchname, o.openbranchname) as openbranchname -- 开户网点名称
    ,nvl(n.repaysignid, o.repaysignid) as repaysignid -- 扣款签约ID
    ,nvl(n.preserialno, o.preserialno) as preserialno -- 记录上次卡变更记录流水号
    ,nvl(n.openname, o.openname) as openname -- 开户名称（人或公司名）
    ,nvl(n.otherbankflag, o.otherbankflag) as otherbankflag -- 他行卡标识(0本行，1他行)
    ,nvl(n.accountnum, o.accountnum) as accountnum -- 账号
    ,nvl(n.bindphone, o.bindphone) as bindphone -- 绑定手机号
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_wl_account_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_wl_account where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.enddate <> n.enddate
        or o.createuser <> n.createuser
        or o.openbankno <> n.openbankno
        or o.fncintcode <> n.fncintcode
        or o.openbranch <> n.openbranch
        or o.migtflag <> n.migtflag
        or o.organcode <> n.organcode
        or o.cardtype <> n.cardtype
        or o.bankpayid <> n.bankpayid
        or o.updatetime <> n.updatetime
        or o.accountname <> n.accountname
        or o.accounttype <> n.accounttype
        or o.openbank <> n.openbank
        or o.updateuser <> n.updateuser
        or o.accountno <> n.accountno
        or o.acctownid <> n.acctownid
        or o.startdate <> n.startdate
        or o.accountflg <> n.accountflg
        or o.createtime <> n.createtime
        or o.assetstype <> n.assetstype
        or o.bindidno <> n.bindidno
        or o.bindcardno <> n.bindcardno
        or o.accountdesc <> n.accountdesc
        or o.openbranchname <> n.openbranchname
        or o.repaysignid <> n.repaysignid
        or o.preserialno <> n.preserialno
        or o.openname <> n.openname
        or o.otherbankflag <> n.otherbankflag
        or o.accountnum <> n.accountnum
        or o.bindphone <> n.bindphone
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wl_account_cl(
            serialno -- 卡变更流水号
            ,enddate -- 分类失效日期
            ,createuser -- 创建用户
            ,openbankno -- 开户行号
            ,fncintcode -- 金融机构编码
            ,openbranch -- 开户网点
            ,migtflag -- 
            ,organcode -- 内部机构编号
            ,cardtype -- 银行卡卡种
            ,bankpayid -- 绑定银行支付ID
            ,updatetime -- 更新时间
            ,accountname -- 账户名称
            ,accounttype -- 账户类型（0-一般户/借记卡，1-基本户/内部户，2-对公保证金户，3-对公活期账户，4-电子账户，9-虚拟账户）
            ,openbank -- 开户行名
            ,updateuser -- 更新用户
            ,accountno -- 账户编号
            ,acctownid -- 账号所属ID(客户编号或者合作机构编号)
            ,startdate -- 分类生效日期
            ,accountflg -- 账户状态，0可用（默认），1不可用
            ,createtime -- 创建时间
            ,assetstype -- 资产方账户类型（1-资金方账户2-资产方账户,3-个人账户）
            ,bindidno -- 绑定身份证号
            ,bindcardno -- 绑定银行卡号
            ,accountdesc -- 账户描述
            ,openbranchname -- 开户网点名称
            ,repaysignid -- 扣款签约ID
            ,preserialno -- 记录上次卡变更记录流水号
            ,openname -- 开户名称（人或公司名）
            ,otherbankflag -- 他行卡标识(0本行，1他行)
            ,accountnum -- 账号
            ,bindphone -- 绑定手机号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wl_account_op(
            serialno -- 卡变更流水号
            ,enddate -- 分类失效日期
            ,createuser -- 创建用户
            ,openbankno -- 开户行号
            ,fncintcode -- 金融机构编码
            ,openbranch -- 开户网点
            ,migtflag -- 
            ,organcode -- 内部机构编号
            ,cardtype -- 银行卡卡种
            ,bankpayid -- 绑定银行支付ID
            ,updatetime -- 更新时间
            ,accountname -- 账户名称
            ,accounttype -- 账户类型（0-一般户/借记卡，1-基本户/内部户，2-对公保证金户，3-对公活期账户，4-电子账户，9-虚拟账户）
            ,openbank -- 开户行名
            ,updateuser -- 更新用户
            ,accountno -- 账户编号
            ,acctownid -- 账号所属ID(客户编号或者合作机构编号)
            ,startdate -- 分类生效日期
            ,accountflg -- 账户状态，0可用（默认），1不可用
            ,createtime -- 创建时间
            ,assetstype -- 资产方账户类型（1-资金方账户2-资产方账户,3-个人账户）
            ,bindidno -- 绑定身份证号
            ,bindcardno -- 绑定银行卡号
            ,accountdesc -- 账户描述
            ,openbranchname -- 开户网点名称
            ,repaysignid -- 扣款签约ID
            ,preserialno -- 记录上次卡变更记录流水号
            ,openname -- 开户名称（人或公司名）
            ,otherbankflag -- 他行卡标识(0本行，1他行)
            ,accountnum -- 账号
            ,bindphone -- 绑定手机号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 卡变更流水号
    ,o.enddate -- 分类失效日期
    ,o.createuser -- 创建用户
    ,o.openbankno -- 开户行号
    ,o.fncintcode -- 金融机构编码
    ,o.openbranch -- 开户网点
    ,o.migtflag -- 
    ,o.organcode -- 内部机构编号
    ,o.cardtype -- 银行卡卡种
    ,o.bankpayid -- 绑定银行支付ID
    ,o.updatetime -- 更新时间
    ,o.accountname -- 账户名称
    ,o.accounttype -- 账户类型（0-一般户/借记卡，1-基本户/内部户，2-对公保证金户，3-对公活期账户，4-电子账户，9-虚拟账户）
    ,o.openbank -- 开户行名
    ,o.updateuser -- 更新用户
    ,o.accountno -- 账户编号
    ,o.acctownid -- 账号所属ID(客户编号或者合作机构编号)
    ,o.startdate -- 分类生效日期
    ,o.accountflg -- 账户状态，0可用（默认），1不可用
    ,o.createtime -- 创建时间
    ,o.assetstype -- 资产方账户类型（1-资金方账户2-资产方账户,3-个人账户）
    ,o.bindidno -- 绑定身份证号
    ,o.bindcardno -- 绑定银行卡号
    ,o.accountdesc -- 账户描述
    ,o.openbranchname -- 开户网点名称
    ,o.repaysignid -- 扣款签约ID
    ,o.preserialno -- 记录上次卡变更记录流水号
    ,o.openname -- 开户名称（人或公司名）
    ,o.otherbankflag -- 他行卡标识(0本行，1他行)
    ,o.accountnum -- 账号
    ,o.bindphone -- 绑定手机号
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
from ${iol_schema}.icms_wl_account_bk o
    left join ${iol_schema}.icms_wl_account_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_wl_account_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_wl_account;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_wl_account') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_wl_account drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_wl_account add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_wl_account exchange partition p_${batch_date} with table ${iol_schema}.icms_wl_account_cl;
alter table ${iol_schema}.icms_wl_account exchange partition p_20991231 with table ${iol_schema}.icms_wl_account_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wl_account to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wl_account_op purge;
drop table ${iol_schema}.icms_wl_account_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_wl_account_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wl_account',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
