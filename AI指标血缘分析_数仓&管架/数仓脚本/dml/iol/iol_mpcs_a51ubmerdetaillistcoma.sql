/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a51ubmerdetaillistcoma
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
drop table ${iol_schema}.mpcs_a51ubmerdetaillistcoma_ex purge;
alter table ${iol_schema}.mpcs_a51ubmerdetaillistcoma add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
-- 3.1 get new data into table
set serveroutput on
--set line 200;
declare bat_dt varchar2(10);
    v_p_exists varchar2(10);
    v_sql varchar2(200);
begin    
--dbms_output.put_line('BBB');
for i in 0 .. 8 loop
    bat_dt := to_char(to_date('${batch_date}','yyyymmdd') - i,'yyyymmdd');
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''mpcs_a51ubmerdetaillistcoma'') and PARTITION_NAME = ''P_'||bat_dt||''' ';
    --dbms_output.put_line(v_sql);
    execute immediate v_sql into v_p_exists;
    --dbms_output.put_line(v_p_exists);
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iol.mpcs_a51ubmerdetaillistcoma truncate partition p_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --dbms_output.put_line('BBB');  
    --no exists partitions  
    else 
        v_sql := 'alter table iol.mpcs_a51ubmerdetaillistcoma add partition p_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
        --dbms_output.put_line('AAA');
    end if;
      end loop;
end;
/

insert /*+ append */ into ${iol_schema}.mpcs_a51ubmerdetaillistcoma(
    acqinstid -- 受理机构号
    ,fwdinstid -- 发送机构号
    ,systrace -- 系统跟踪号
    ,transtime -- 交易传输时间
    ,transdate -- 交易日期
    ,priacct -- 卡号
    ,msgtype -- 消息类型
    ,procecode -- 交易处理码
    ,transamt -- 交易金额
    ,handfeeinfo -- 手续费信息
    ,mchnttype -- 商户类型
    ,retrivarefnum -- 参考检索号
    ,authridresp -- 预授权返回码
    ,respcode -- 交易应答码
    ,acptermnlid -- 受理终端号
    ,accptrid -- 受理商户号
    ,currcycode -- 交易币种
    ,tranflag -- 借贷标志位 贷记为C，借记为D
    ,merfee -- 商户手续费
    ,tranamt -- 应付金额
    ,recvamt -- 应收金额
    ,stransno -- 发送机构流水号
    ,stranstag -- 
    ,remark1 -- 服务码
    ,remark2 -- 交易名称
    ,remark3 -- 商户名字地址
    ,remark4 -- 批次号
    ,remark5 -- 
    ,status -- 状态 0:预登记 1:已处理 2:失败 9:已入批次
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acqinstid -- 受理机构号
    ,fwdinstid -- 发送机构号
    ,systrace -- 系统跟踪号
    ,transtime -- 交易传输时间
    ,transdate -- 交易日期
    ,priacct -- 卡号
    ,msgtype -- 消息类型
    ,procecode -- 交易处理码
    ,transamt -- 交易金额
    ,handfeeinfo -- 手续费信息
    ,mchnttype -- 商户类型
    ,retrivarefnum -- 参考检索号
    ,authridresp -- 预授权返回码
    ,respcode -- 交易应答码
    ,acptermnlid -- 受理终端号
    ,accptrid -- 受理商户号
    ,currcycode -- 交易币种
    ,tranflag -- 借贷标志位 贷记为C，借记为D
    ,merfee -- 商户手续费
    ,tranamt -- 应付金额
    ,recvamt -- 应收金额
    ,stransno -- 发送机构流水号
    ,stranstag -- 
    ,remark1 -- 服务码
    ,remark2 -- 交易名称
    ,remark3 -- 商户名字地址
    ,remark4 -- 批次号
    ,remark5 -- 
    ,status -- 状态 0:预登记 1:已处理 2:失败 9:已入批次
    ,to_date(transdate,'yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a51ubmerdetaillistcoma
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;
commit;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a51ubmerdetaillistcoma to ${iml_schema};

-- 3.2 drop ex table

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a51ubmerdetaillistcoma',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);