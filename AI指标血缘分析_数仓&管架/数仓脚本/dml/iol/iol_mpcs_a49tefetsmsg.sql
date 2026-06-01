/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a49tefetsmsg
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a49tefetsmsg_ex purge;
alter table ${iol_schema}.mpcs_a49tefetsmsg add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
-- 3.1 get new data into table
set serveroutput on
--set line 200;
declare bat_dt varchar2(10);
    v_p_exists varchar2(10);
    v_sql varchar2(200);
begin    
--dbms_output.put_line('BBB');
for i in 0 .. 14 loop
    bat_dt := to_char(to_date('${batch_date}','yyyymmdd') - i,'yyyymmdd');
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''mpcs_a49tefetsmsg'') and PARTITION_NAME = ''P_'||bat_dt||''' ';
    --dbms_output.put_line(v_sql);
    execute immediate v_sql into v_p_exists;
    --dbms_output.put_line(v_p_exists);
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iol.mpcs_a49tefetsmsg truncate partition p_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --dbms_output.put_line('BBB');  
    --no exists partitions  
    else 
        v_sql := 'alter table iol.mpcs_a49tefetsmsg add partition p_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
        --dbms_output.put_line('AAA');
    end if;
      end loop;
end;
/

insert /*+ append */ into ${iol_schema}.mpcs_a49tefetsmsg(
    trandt -- 交易日期
    ,transq -- 交易流水号
    ,trantm -- 交易时间
    ,iotype -- 来往标识
    ,transt -- 交易状态
    ,sysid -- 发起方系统号
    ,sndzone -- 发起地区代码
    ,rcvzone -- 接收地区代码
    ,msgno -- 报文编号
    ,msgid -- 信息序号
    ,origmsgid -- 原信息序号
    ,txntype -- 交易类型细分
    ,entrustdate -- 委托日期
    ,sendbank -- 发起行行号/机构号
    ,recvbank -- 接收行行号/机构号
    ,oprchl -- 业务渠道
    ,recvaccbank -- 接收账户行
    ,msgtype -- ETS信息类型
    ,origdt -- 征收机关提交日期
    ,origcd -- 征收机关代码
    ,origsq -- 征收机关流水号(申报流水号)
    ,mainbr -- 经收处银行号
    ,tranid -- 银行交易识别号
    ,txpycd -- 纳税人编码
    ,oprtype -- 交易类型
    ,txbrch -- 机关类别
    ,torigdt -- 对照征收机关提交日期
    ,torigsq -- 对照流水号
    ,fisccd -- 收款国库代码
    ,prodcd -- 处理返回码
    ,payeracc -- 付款账号
    ,amount -- 交易金额
    ,payecd -- 缴款方式代码
    ,txndate -- 清算日期
    ,logadt -- ETS资金对数日期
    ,logact -- ETS资金对数场次
    ,tolcnt -- 交易合计的笔数
    ,tolamt -- 交易合计的金额
    ,retcd -- 返回码
    ,remark -- 附言
    ,brchno -- 营业点
    ,userid -- 柜员号
    ,ckbkus -- 授权柜员
    ,ckbkbr -- 授权网点
    ,linkid -- 链路ID
    ,txpyna -- 纳税人名称
    ,bustype -- 业务类型
    ,cpnytp -- 企业注册类型代码
    ,dtlrmk -- 明细备注
    ,dtllng -- 明细长度
    ,idtype -- 证件类型
    ,idno -- 证件号码
    ,name -- 姓名
    ,cnpysbid -- 单位社保号
    ,bizid -- 业务种类代码
    ,lmtpaydt -- 限缴日期
    ,orignm -- 征收机关名称
    ,oribkid -- 原业务银行交易识别号
    ,oribkdt -- 原业务银行提交日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    trandt -- 交易日期
    ,transq -- 交易流水号
    ,trantm -- 交易时间
    ,iotype -- 来往标识
    ,transt -- 交易状态
    ,sysid -- 发起方系统号
    ,sndzone -- 发起地区代码
    ,rcvzone -- 接收地区代码
    ,msgno -- 报文编号
    ,msgid -- 信息序号
    ,origmsgid -- 原信息序号
    ,txntype -- 交易类型细分
    ,entrustdate -- 委托日期
    ,sendbank -- 发起行行号/机构号
    ,recvbank -- 接收行行号/机构号
    ,oprchl -- 业务渠道
    ,recvaccbank -- 接收账户行
    ,msgtype -- ETS信息类型
    ,origdt -- 征收机关提交日期
    ,origcd -- 征收机关代码
    ,origsq -- 征收机关流水号(申报流水号)
    ,mainbr -- 经收处银行号
    ,tranid -- 银行交易识别号
    ,txpycd -- 纳税人编码
    ,oprtype -- 交易类型
    ,txbrch -- 机关类别
    ,torigdt -- 对照征收机关提交日期
    ,torigsq -- 对照流水号
    ,fisccd -- 收款国库代码
    ,prodcd -- 处理返回码
    ,payeracc -- 付款账号
    ,amount -- 交易金额
    ,payecd -- 缴款方式代码
    ,txndate -- 清算日期
    ,logadt -- ETS资金对数日期
    ,logact -- ETS资金对数场次
    ,tolcnt -- 交易合计的笔数
    ,tolamt -- 交易合计的金额
    ,retcd -- 返回码
    ,remark -- 附言
    ,brchno -- 营业点
    ,userid -- 柜员号
    ,ckbkus -- 授权柜员
    ,ckbkbr -- 授权网点
    ,linkid -- 链路ID
    ,txpyna -- 纳税人名称
    ,bustype -- 业务类型
    ,cpnytp -- 企业注册类型代码
    ,dtlrmk -- 明细备注
    ,dtllng -- 明细长度
    ,idtype -- 证件类型
    ,idno -- 证件号码
    ,name -- 姓名
    ,cnpysbid -- 单位社保号
    ,bizid -- 业务种类代码
    ,lmtpaydt -- 限缴日期
    ,orignm -- 征收机关名称
    ,oribkid -- 原业务银行交易识别号
    ,oribkdt -- 原业务银行提交日期
    ,to_date(trandt,'yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a49tefetsmsg
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;
commit;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a49tefetsmsg to ${iml_schema};

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a49tefetsmsg',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);