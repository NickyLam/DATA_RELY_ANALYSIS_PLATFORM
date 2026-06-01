/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_zxz_package_info
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
create table ${iol_schema}.icms_zxz_package_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_zxz_package_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_zxz_package_info_op purge;
drop table ${iol_schema}.icms_zxz_package_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_zxz_package_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_zxz_package_info where 0=1;

create table ${iol_schema}.icms_zxz_package_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_zxz_package_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_zxz_package_info_cl(
            packageno -- 编号
            ,putoutaccount -- 资金划出账户
            ,bpfilename -- 人行文件名称
            ,bplimit -- （人行额度（元）
            ,pledgesum -- 抵质押物金额（估值)(小计)
            ,inputaccount -- 资金划入账户
            ,belongpbunitleadername -- 所属地人民银行单位负责人姓名
            ,belongpbname -- 所属地人民银行名称
            ,relpackagename -- 关联批次包名称
            ,usedesc -- 使用要求
            ,applyamount -- 再贷款金额
            ,zxzrealityiry -- 使用利率
            ,relpackageno -- 关联批次包编号关联一、二级批次包
            ,zxzcontno -- 再贷款合同编号
            ,zxzloanstartdate -- 再贷款发放日期
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,migtflag -- 
            ,failreason -- 备注
            ,creditortype -- 人民银行债权类型
            ,bpfileusedate -- 人行文件发文日期
            ,inputorgid -- 登记机构
            ,loanstype -- 再贷款类型
            ,unitphone -- 单位地址联系电话
            ,unitaddress -- 单位地址
            ,packagename -- 批次包的名称
            ,loanbalance -- 剩余额度
            ,zxzloanmode -- 再贷款发放模式
            ,belongpborgid -- 所属地人民银行金融机构编码
            ,bearingtype -- 计息方式
            ,creditorbalance -- 债权余额
            ,packageflag -- 批次包标识1：一级包2：二级包
            ,packagestatus -- 批次包状态
            ,zxzenddate -- 再贷款到期日期
            ,bpfileno -- 人行文件文号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_zxz_package_info_op(
            packageno -- 编号
            ,putoutaccount -- 资金划出账户
            ,bpfilename -- 人行文件名称
            ,bplimit -- （人行额度（元）
            ,pledgesum -- 抵质押物金额（估值)(小计)
            ,inputaccount -- 资金划入账户
            ,belongpbunitleadername -- 所属地人民银行单位负责人姓名
            ,belongpbname -- 所属地人民银行名称
            ,relpackagename -- 关联批次包名称
            ,usedesc -- 使用要求
            ,applyamount -- 再贷款金额
            ,zxzrealityiry -- 使用利率
            ,relpackageno -- 关联批次包编号关联一、二级批次包
            ,zxzcontno -- 再贷款合同编号
            ,zxzloanstartdate -- 再贷款发放日期
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,migtflag -- 
            ,failreason -- 备注
            ,creditortype -- 人民银行债权类型
            ,bpfileusedate -- 人行文件发文日期
            ,inputorgid -- 登记机构
            ,loanstype -- 再贷款类型
            ,unitphone -- 单位地址联系电话
            ,unitaddress -- 单位地址
            ,packagename -- 批次包的名称
            ,loanbalance -- 剩余额度
            ,zxzloanmode -- 再贷款发放模式
            ,belongpborgid -- 所属地人民银行金融机构编码
            ,bearingtype -- 计息方式
            ,creditorbalance -- 债权余额
            ,packageflag -- 批次包标识1：一级包2：二级包
            ,packagestatus -- 批次包状态
            ,zxzenddate -- 再贷款到期日期
            ,bpfileno -- 人行文件文号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.packageno, o.packageno) as packageno -- 编号
    ,nvl(n.putoutaccount, o.putoutaccount) as putoutaccount -- 资金划出账户
    ,nvl(n.bpfilename, o.bpfilename) as bpfilename -- 人行文件名称
    ,nvl(n.bplimit, o.bplimit) as bplimit -- （人行额度（元）
    ,nvl(n.pledgesum, o.pledgesum) as pledgesum -- 抵质押物金额（估值)(小计)
    ,nvl(n.inputaccount, o.inputaccount) as inputaccount -- 资金划入账户
    ,nvl(n.belongpbunitleadername, o.belongpbunitleadername) as belongpbunitleadername -- 所属地人民银行单位负责人姓名
    ,nvl(n.belongpbname, o.belongpbname) as belongpbname -- 所属地人民银行名称
    ,nvl(n.relpackagename, o.relpackagename) as relpackagename -- 关联批次包名称
    ,nvl(n.usedesc, o.usedesc) as usedesc -- 使用要求
    ,nvl(n.applyamount, o.applyamount) as applyamount -- 再贷款金额
    ,nvl(n.zxzrealityiry, o.zxzrealityiry) as zxzrealityiry -- 使用利率
    ,nvl(n.relpackageno, o.relpackageno) as relpackageno -- 关联批次包编号关联一、二级批次包
    ,nvl(n.zxzcontno, o.zxzcontno) as zxzcontno -- 再贷款合同编号
    ,nvl(n.zxzloanstartdate, o.zxzloanstartdate) as zxzloanstartdate -- 再贷款发放日期
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.failreason, o.failreason) as failreason -- 备注
    ,nvl(n.creditortype, o.creditortype) as creditortype -- 人民银行债权类型
    ,nvl(n.bpfileusedate, o.bpfileusedate) as bpfileusedate -- 人行文件发文日期
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.loanstype, o.loanstype) as loanstype -- 再贷款类型
    ,nvl(n.unitphone, o.unitphone) as unitphone -- 单位地址联系电话
    ,nvl(n.unitaddress, o.unitaddress) as unitaddress -- 单位地址
    ,nvl(n.packagename, o.packagename) as packagename -- 批次包的名称
    ,nvl(n.loanbalance, o.loanbalance) as loanbalance -- 剩余额度
    ,nvl(n.zxzloanmode, o.zxzloanmode) as zxzloanmode -- 再贷款发放模式
    ,nvl(n.belongpborgid, o.belongpborgid) as belongpborgid -- 所属地人民银行金融机构编码
    ,nvl(n.bearingtype, o.bearingtype) as bearingtype -- 计息方式
    ,nvl(n.creditorbalance, o.creditorbalance) as creditorbalance -- 债权余额
    ,nvl(n.packageflag, o.packageflag) as packageflag -- 批次包标识1：一级包2：二级包
    ,nvl(n.packagestatus, o.packagestatus) as packagestatus -- 批次包状态
    ,nvl(n.zxzenddate, o.zxzenddate) as zxzenddate -- 再贷款到期日期
    ,nvl(n.bpfileno, o.bpfileno) as bpfileno -- 人行文件文号
    ,case when
            n.packageno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.packageno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.packageno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_zxz_package_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_zxz_package_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.packageno = n.packageno
where (
        o.packageno is null
    )
    or (
        n.packageno is null
    )
    or (
        o.putoutaccount <> n.putoutaccount
        or o.bpfilename <> n.bpfilename
        or o.bplimit <> n.bplimit
        or o.pledgesum <> n.pledgesum
        or o.inputaccount <> n.inputaccount
        or o.belongpbunitleadername <> n.belongpbunitleadername
        or o.belongpbname <> n.belongpbname
        or o.relpackagename <> n.relpackagename
        or o.usedesc <> n.usedesc
        or o.applyamount <> n.applyamount
        or o.zxzrealityiry <> n.zxzrealityiry
        or o.relpackageno <> n.relpackageno
        or o.zxzcontno <> n.zxzcontno
        or o.zxzloanstartdate <> n.zxzloanstartdate
        or o.inputuserid <> n.inputuserid
        or o.inputdate <> n.inputdate
        or o.migtflag <> n.migtflag
        or o.failreason <> n.failreason
        or o.creditortype <> n.creditortype
        or o.bpfileusedate <> n.bpfileusedate
        or o.inputorgid <> n.inputorgid
        or o.loanstype <> n.loanstype
        or o.unitphone <> n.unitphone
        or o.unitaddress <> n.unitaddress
        or o.packagename <> n.packagename
        or o.loanbalance <> n.loanbalance
        or o.zxzloanmode <> n.zxzloanmode
        or o.belongpborgid <> n.belongpborgid
        or o.bearingtype <> n.bearingtype
        or o.creditorbalance <> n.creditorbalance
        or o.packageflag <> n.packageflag
        or o.packagestatus <> n.packagestatus
        or o.zxzenddate <> n.zxzenddate
        or o.bpfileno <> n.bpfileno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_zxz_package_info_cl(
            packageno -- 编号
            ,putoutaccount -- 资金划出账户
            ,bpfilename -- 人行文件名称
            ,bplimit -- （人行额度（元）
            ,pledgesum -- 抵质押物金额（估值)(小计)
            ,inputaccount -- 资金划入账户
            ,belongpbunitleadername -- 所属地人民银行单位负责人姓名
            ,belongpbname -- 所属地人民银行名称
            ,relpackagename -- 关联批次包名称
            ,usedesc -- 使用要求
            ,applyamount -- 再贷款金额
            ,zxzrealityiry -- 使用利率
            ,relpackageno -- 关联批次包编号关联一、二级批次包
            ,zxzcontno -- 再贷款合同编号
            ,zxzloanstartdate -- 再贷款发放日期
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,migtflag -- 
            ,failreason -- 备注
            ,creditortype -- 人民银行债权类型
            ,bpfileusedate -- 人行文件发文日期
            ,inputorgid -- 登记机构
            ,loanstype -- 再贷款类型
            ,unitphone -- 单位地址联系电话
            ,unitaddress -- 单位地址
            ,packagename -- 批次包的名称
            ,loanbalance -- 剩余额度
            ,zxzloanmode -- 再贷款发放模式
            ,belongpborgid -- 所属地人民银行金融机构编码
            ,bearingtype -- 计息方式
            ,creditorbalance -- 债权余额
            ,packageflag -- 批次包标识1：一级包2：二级包
            ,packagestatus -- 批次包状态
            ,zxzenddate -- 再贷款到期日期
            ,bpfileno -- 人行文件文号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_zxz_package_info_op(
            packageno -- 编号
            ,putoutaccount -- 资金划出账户
            ,bpfilename -- 人行文件名称
            ,bplimit -- （人行额度（元）
            ,pledgesum -- 抵质押物金额（估值)(小计)
            ,inputaccount -- 资金划入账户
            ,belongpbunitleadername -- 所属地人民银行单位负责人姓名
            ,belongpbname -- 所属地人民银行名称
            ,relpackagename -- 关联批次包名称
            ,usedesc -- 使用要求
            ,applyamount -- 再贷款金额
            ,zxzrealityiry -- 使用利率
            ,relpackageno -- 关联批次包编号关联一、二级批次包
            ,zxzcontno -- 再贷款合同编号
            ,zxzloanstartdate -- 再贷款发放日期
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,migtflag -- 
            ,failreason -- 备注
            ,creditortype -- 人民银行债权类型
            ,bpfileusedate -- 人行文件发文日期
            ,inputorgid -- 登记机构
            ,loanstype -- 再贷款类型
            ,unitphone -- 单位地址联系电话
            ,unitaddress -- 单位地址
            ,packagename -- 批次包的名称
            ,loanbalance -- 剩余额度
            ,zxzloanmode -- 再贷款发放模式
            ,belongpborgid -- 所属地人民银行金融机构编码
            ,bearingtype -- 计息方式
            ,creditorbalance -- 债权余额
            ,packageflag -- 批次包标识1：一级包2：二级包
            ,packagestatus -- 批次包状态
            ,zxzenddate -- 再贷款到期日期
            ,bpfileno -- 人行文件文号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.packageno -- 编号
    ,o.putoutaccount -- 资金划出账户
    ,o.bpfilename -- 人行文件名称
    ,o.bplimit -- （人行额度（元）
    ,o.pledgesum -- 抵质押物金额（估值)(小计)
    ,o.inputaccount -- 资金划入账户
    ,o.belongpbunitleadername -- 所属地人民银行单位负责人姓名
    ,o.belongpbname -- 所属地人民银行名称
    ,o.relpackagename -- 关联批次包名称
    ,o.usedesc -- 使用要求
    ,o.applyamount -- 再贷款金额
    ,o.zxzrealityiry -- 使用利率
    ,o.relpackageno -- 关联批次包编号关联一、二级批次包
    ,o.zxzcontno -- 再贷款合同编号
    ,o.zxzloanstartdate -- 再贷款发放日期
    ,o.inputuserid -- 登记人
    ,o.inputdate -- 登记日期
    ,o.migtflag -- 
    ,o.failreason -- 备注
    ,o.creditortype -- 人民银行债权类型
    ,o.bpfileusedate -- 人行文件发文日期
    ,o.inputorgid -- 登记机构
    ,o.loanstype -- 再贷款类型
    ,o.unitphone -- 单位地址联系电话
    ,o.unitaddress -- 单位地址
    ,o.packagename -- 批次包的名称
    ,o.loanbalance -- 剩余额度
    ,o.zxzloanmode -- 再贷款发放模式
    ,o.belongpborgid -- 所属地人民银行金融机构编码
    ,o.bearingtype -- 计息方式
    ,o.creditorbalance -- 债权余额
    ,o.packageflag -- 批次包标识1：一级包2：二级包
    ,o.packagestatus -- 批次包状态
    ,o.zxzenddate -- 再贷款到期日期
    ,o.bpfileno -- 人行文件文号
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
from ${iol_schema}.icms_zxz_package_info_bk o
    left join ${iol_schema}.icms_zxz_package_info_op n
        on
            o.packageno = n.packageno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_zxz_package_info_cl d
        on
            o.packageno = d.packageno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_zxz_package_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_zxz_package_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_zxz_package_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_zxz_package_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_zxz_package_info exchange partition p_${batch_date} with table ${iol_schema}.icms_zxz_package_info_cl;
alter table ${iol_schema}.icms_zxz_package_info exchange partition p_20991231 with table ${iol_schema}.icms_zxz_package_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_zxz_package_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_zxz_package_info_op purge;
drop table ${iol_schema}.icms_zxz_package_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_zxz_package_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_zxz_package_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
