/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_hstctrans1_v_tbgrphissaleshare
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
drop table ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare_ex purge;
alter table ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
-- 2.2.1 get new data into table
set serveroutput on
declare bat_dt varchar2(10);
    v_p_exists varchar2(10);
    v_sql varchar2(200);
begin    
for i in 0 .. 14 loop
    bat_dt := to_char(to_date('${batch_date}','yyyymmdd') - i,'yyyymmdd');
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''nfss_hstctrans1_v_tbgrphissaleshare'') and PARTITION_NAME = ''P_'||bat_dt||''' ';
    execute immediate v_sql into v_p_exists;
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iol.nfss_hstctrans1_v_tbgrphissaleshare truncate partition p_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --no exists partitions  
    else 
        v_sql := 'alter table iol.nfss_hstctrans1_v_tbgrphissaleshare add partition p_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    end if;
      end loop;
end;
/


-- 2.3 insert data to ex table
create table ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare where 0=1;

insert /*+ append */ into ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare(
    import_date -- 导入日期
    ,seller_code -- 销售商代码
    ,bank_no -- 银行代码:租户编号(多租户模式用)
    ,client_no -- 银行客户号
    ,bank_acc -- 资金账号
    ,virtual_bank_acc -- 虚拟银行账号
    ,ta_client -- ta交易账号
    ,prd_type -- 产品类型:1-基金
    ,cash_flag -- 钞汇标志:[k_chbz] 0-现钞 1-现汇 2-钞汇均可
    ,trans_account_type -- 交易介质类型:[k_khbslx] 0-入账账号 1-客户号 2-证件
    ,trans_account -- 交易账号:交易介质
    ,ta_code -- ta代码
    ,asset_acc -- 理财账号
    ,prd_code -- 产品代码
    ,tot_vol -- 总份额
    ,frozen_vol -- 冻结份额
    ,long_frozen_vol -- 长期冻结份额
    ,group_vol -- 组合投资份额
    ,div_mode -- 分红方式:0红利再投资,1现金红利
    ,old_div_mode -- 原分红方式:[k_fhfs] 0-红利转投 1-现金分红 2-利得现金增值再投资 3-增值现金利得再投资 4-部分再投资 5-赠送
    ,div_rate -- 分红比例
    ,ystdy_tot_vol -- 昨日总份额
    ,open_branch -- 所属机构
    ,client_type -- 客户类型:k_khlx 0-机构 1-个人
    ,other_frozen -- 本地冻结份额
    ,cost -- 成本:本金
    ,prd_value -- 产品市值
    ,tot_income -- 累计收入
    ,onway_amt -- 在途资金:接口用标准字段
    ,profit_loss -- 浮动盈亏
    ,income_onway -- 未付收益
    ,income_frozen -- 冻结的未付收益
    ,income_new -- 当天新增未付收益
    ,tot_amt -- 总金额
    ,use_amt -- 当前可用额度:接口用标准字段
    ,income_date -- 收益日期
    ,reserve1 -- 保留字段1
    ,reserve2 -- 保留字段2
    ,reserve3 -- 保留字段3
    ,reserve4 -- 保留字段4
    ,reserve5 -- 保留字段5
    ,in_client_no -- 内部客户编号
    ,modify_timestamp -- 修改时间戳
    ,group_code -- 分组代码
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    import_date -- 导入日期
    ,seller_code -- 销售商代码
    ,bank_no -- 银行代码:租户编号(多租户模式用)
    ,client_no -- 银行客户号
    ,bank_acc -- 资金账号
    ,virtual_bank_acc -- 虚拟银行账号
    ,ta_client -- ta交易账号
    ,prd_type -- 产品类型:1-基金
    ,cash_flag -- 钞汇标志:[k_chbz] 0-现钞 1-现汇 2-钞汇均可
    ,trans_account_type -- 交易介质类型:[k_khbslx] 0-入账账号 1-客户号 2-证件
    ,trans_account -- 交易账号:交易介质
    ,ta_code -- ta代码
    ,asset_acc -- 理财账号
    ,prd_code -- 产品代码
    ,tot_vol -- 总份额
    ,frozen_vol -- 冻结份额
    ,long_frozen_vol -- 长期冻结份额
    ,group_vol -- 组合投资份额
    ,div_mode -- 分红方式:0红利再投资,1现金红利
    ,old_div_mode -- 原分红方式:[k_fhfs] 0-红利转投 1-现金分红 2-利得现金增值再投资 3-增值现金利得再投资 4-部分再投资 5-赠送
    ,div_rate -- 分红比例
    ,ystdy_tot_vol -- 昨日总份额
    ,open_branch -- 所属机构
    ,client_type -- 客户类型:k_khlx 0-机构 1-个人
    ,other_frozen -- 本地冻结份额
    ,cost -- 成本:本金
    ,prd_value -- 产品市值
    ,tot_income -- 累计收入
    ,onway_amt -- 在途资金:接口用标准字段
    ,profit_loss -- 浮动盈亏
    ,income_onway -- 未付收益
    ,income_frozen -- 冻结的未付收益
    ,income_new -- 当天新增未付收益
    ,tot_amt -- 总金额
    ,use_amt -- 当前可用额度:接口用标准字段
    ,income_date -- 收益日期
    ,reserve1 -- 保留字段1
    ,reserve2 -- 保留字段2
    ,reserve3 -- 保留字段3
    ,reserve4 -- 保留字段4
    ,reserve5 -- 保留字段5
    ,in_client_no -- 内部客户编号
    ,modify_timestamp -- 修改时间戳
    ,group_code -- 分组代码
   ,to_date(import_date,'yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.nfss_hstctrans1_v_tbgrphissaleshare
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table


-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.nfss_hstctrans1_v_tbgrphissaleshare_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_hstctrans1_v_tbgrphissaleshare',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);