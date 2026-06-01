/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ext_cap_acct_ibmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_ext_cap_acct_ibmsf1_tm purge;
drop table ${iml_schema}.agt_ext_cap_acct_ibmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_ext_cap_acct add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_ext_cap_acct modify partition p_ibmsf1
    add subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ext_cap_acct_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ext_cap_acct partition for ('ibmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ext_cap_acct_ibmsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,tran_market_id -- 交易市场编号
    ,exchg_acct_id -- 交易所账户编号
    ,curr_cd -- 币种代码
    ,open_acct_bank_no -- 开户银行行号
    ,open_acct_bank_name -- 开户银行名称
    ,open_acct_dt -- 开户日期
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,intnal_cap_acct_num -- 内部资金账号
    ,cap_acct_type_cd -- 资金账户类型代码
    ,intnal_acct_num -- 内部账号
    ,entry_org_id -- 记账机构编号
    ,intnal_acct_name -- 内部账名称
    ,src_pay_int_ped_cd -- 源付息周期代码
    ,pay_int_ped_corp_cd -- 付息周期单位代码
    ,pay_int_ped_freq -- 付息周期频率
    ,int_rat_def_id -- 利率定义编号
    ,cap_type_cd -- 资金类型代码
    ,pay_mon -- 支付月份
    ,pay_days -- 支付天数
    ,int_rat -- 利率
    ,clos_acct_dt -- 销户日期
    ,prod_type_id -- 产品类型编号
    ,prod_cls_name -- 产品分类名称
    ,subj_id -- 科目编号
    ,swift_cd -- SWIFT代码
    ,belong_org_id -- 所属机构编号
    ,acct_char_descb -- 账户性质描述
    ,acct_attr_descb -- 账户属性描述
    ,cross_bor_ibank_nostro_acct_id -- 跨境同业往来账户编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ext_cap_acct
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_ext_cap_acct_ibmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_ext_cap_acct partition for ('ibmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ibms_ttrd_acc_cash_ext-
insert into ${iml_schema}.agt_ext_cap_acct_ibmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,tran_market_id -- 交易市场编号
    ,exchg_acct_id -- 交易所账户编号
    ,curr_cd -- 币种代码
    ,open_acct_bank_no -- 开户银行行号
    ,open_acct_bank_name -- 开户银行名称
    ,open_acct_dt -- 开户日期
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,intnal_cap_acct_num -- 内部资金账号
    ,cap_acct_type_cd -- 资金账户类型代码
    ,intnal_acct_num -- 内部账号
    ,entry_org_id -- 记账机构编号
    ,intnal_acct_name -- 内部账名称
    ,src_pay_int_ped_cd -- 源付息周期代码
    ,pay_int_ped_corp_cd -- 付息周期单位代码
    ,pay_int_ped_freq -- 付息周期频率
    ,int_rat_def_id -- 利率定义编号
    ,cap_type_cd -- 资金类型代码
    ,pay_mon -- 支付月份
    ,pay_days -- 支付天数
    ,int_rat -- 利率
    ,clos_acct_dt -- 销户日期
    ,prod_type_id -- 产品类型编号
    ,prod_cls_name -- 产品分类名称
    ,subj_id -- 科目编号
    ,swift_cd -- SWIFT代码
    ,belong_org_id -- 所属机构编号
    ,acct_char_descb -- 账户性质描述
    ,acct_attr_descb -- 账户属性描述
    ,cross_bor_ibank_nostro_acct_id -- 跨境同业往来账户编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '100043'||P1.ACCID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ACCID -- 账户编号
    ,P1.ACCNAME -- 账户名称
    ,P1.MARKETS -- 交易市场编号
    ,P1.EXHACC -- 交易所账户编号
    ,P1.CURRENCY -- 币种代码
    ,P1.BANK_CODE -- 开户银行行号
    ,P1.BANK_NAME -- 开户银行名称
    ,${iml_schema}.DATEFORMAT_MIN(P1.OPEN_DATE) -- 开户日期
    ,P1.CUSTOMER_ID -- 交易对手编号
    ,P1.CUSTOMER_NAME -- 交易对手名称
    ,P1.INNER_ACCID -- 内部资金账号
    ,nvl(trim(P1.ACCOUNTTYPE),'0') -- 资金账户类型代码
    ,P1.INNER_CODE -- 内部账号
    ,P1.OLDINST_ID -- 记账机构编号
    ,P1.INNER_ACCNAME -- 内部账名称
    ,P1.PAYMENT_FREQ -- 源付息周期代码
    ,SUBSTR(decode(P1.PAYMENT_FREQ,'-1','0D',P1.PAYMENT_FREQ),-1,1) -- 付息周期单位代码
    ,SUBSTR(decode(P1.PAYMENT_FREQ,'-1','0D',P1.PAYMENT_FREQ),1,length(P1.PAYMENT_FREQ)-1) -- 付息周期频率
    ,P1.RATE_DEF_ID -- 利率定义编号
    ,P1.INVEST_TYPE -- 资金类型代码
    ,P1.PAY_MONTH -- 支付月份
    ,P1.PAY_DAY -- 支付天数
    ,P1.COUPON -- 利率
    ,${iml_schema}.DATEFORMAT_MAX(P1.CLOSE_DATE) -- 销户日期
    ,P1.P_TYPE -- 产品类型编号
    ,P1.P_CLASS -- 产品分类名称
    ,P1.SUBJ_CODE -- 科目编号
    ,P1.SWIFT_CODE -- SWIFT代码
    ,P2.ORG_ID -- 所属机构编号
    ,P1.ACCOUNT_NATURE -- 账户性质描述
    ,P1.ACCOUNT_ATTRIBUTE -- 账户属性描述
    ,P1.CROSS_BORDER_ACC -- 跨境同业往来账户编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_acc_cash_ext' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_acc_cash_ext p1
    left join ${iol_schema}.ibms_ttrd_institution p2 on P1.I_ID=P2.I_ID AND P2.start_dt <= to_date('${batch_date}','yyyymmdd') and P2.end_dt > to_date('${batch_date}','yyyymmdd')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_ext_cap_acct_ibmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_ext_cap_acct_ibmsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,tran_market_id -- 交易市场编号
    ,exchg_acct_id -- 交易所账户编号
    ,curr_cd -- 币种代码
    ,open_acct_bank_no -- 开户银行行号
    ,open_acct_bank_name -- 开户银行名称
    ,open_acct_dt -- 开户日期
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,intnal_cap_acct_num -- 内部资金账号
    ,cap_acct_type_cd -- 资金账户类型代码
    ,intnal_acct_num -- 内部账号
    ,entry_org_id -- 记账机构编号
    ,intnal_acct_name -- 内部账名称
    ,src_pay_int_ped_cd -- 源付息周期代码
    ,pay_int_ped_corp_cd -- 付息周期单位代码
    ,pay_int_ped_freq -- 付息周期频率
    ,int_rat_def_id -- 利率定义编号
    ,cap_type_cd -- 资金类型代码
    ,pay_mon -- 支付月份
    ,pay_days -- 支付天数
    ,int_rat -- 利率
    ,clos_acct_dt -- 销户日期
    ,prod_type_id -- 产品类型编号
    ,prod_cls_name -- 产品分类名称
    ,subj_id -- 科目编号
    ,swift_cd -- SWIFT代码
    ,belong_org_id -- 所属机构编号
    ,acct_char_descb -- 账户性质描述
    ,acct_attr_descb -- 账户属性描述
    ,cross_bor_ibank_nostro_acct_id -- 跨境同业往来账户编号
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.tran_market_id, o.tran_market_id) as tran_market_id -- 交易市场编号
    ,nvl(n.exchg_acct_id, o.exchg_acct_id) as exchg_acct_id -- 交易所账户编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.open_acct_bank_no, o.open_acct_bank_no) as open_acct_bank_no -- 开户银行行号
    ,nvl(n.open_acct_bank_name, o.open_acct_bank_name) as open_acct_bank_name -- 开户银行名称
    ,nvl(n.open_acct_dt, o.open_acct_dt) as open_acct_dt -- 开户日期
    ,nvl(n.cntpty_id, o.cntpty_id) as cntpty_id -- 交易对手编号
    ,nvl(n.cntpty_name, o.cntpty_name) as cntpty_name -- 交易对手名称
    ,nvl(n.intnal_cap_acct_num, o.intnal_cap_acct_num) as intnal_cap_acct_num -- 内部资金账号
    ,nvl(n.cap_acct_type_cd, o.cap_acct_type_cd) as cap_acct_type_cd -- 资金账户类型代码
    ,nvl(n.intnal_acct_num, o.intnal_acct_num) as intnal_acct_num -- 内部账号
    ,nvl(n.entry_org_id, o.entry_org_id) as entry_org_id -- 记账机构编号
    ,nvl(n.intnal_acct_name, o.intnal_acct_name) as intnal_acct_name -- 内部账名称
    ,nvl(n.src_pay_int_ped_cd, o.src_pay_int_ped_cd) as src_pay_int_ped_cd -- 源付息周期代码
    ,nvl(n.pay_int_ped_corp_cd, o.pay_int_ped_corp_cd) as pay_int_ped_corp_cd -- 付息周期单位代码
    ,nvl(n.pay_int_ped_freq, o.pay_int_ped_freq) as pay_int_ped_freq -- 付息周期频率
    ,nvl(n.int_rat_def_id, o.int_rat_def_id) as int_rat_def_id -- 利率定义编号
    ,nvl(n.cap_type_cd, o.cap_type_cd) as cap_type_cd -- 资金类型代码
    ,nvl(n.pay_mon, o.pay_mon) as pay_mon -- 支付月份
    ,nvl(n.pay_days, o.pay_days) as pay_days -- 支付天数
    ,nvl(n.int_rat, o.int_rat) as int_rat -- 利率
    ,nvl(n.clos_acct_dt, o.clos_acct_dt) as clos_acct_dt -- 销户日期
    ,nvl(n.prod_type_id, o.prod_type_id) as prod_type_id -- 产品类型编号
    ,nvl(n.prod_cls_name, o.prod_cls_name) as prod_cls_name -- 产品分类名称
    ,nvl(n.subj_id, o.subj_id) as subj_id -- 科目编号
    ,nvl(n.swift_cd, o.swift_cd) as swift_cd -- SWIFT代码
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.acct_char_descb, o.acct_char_descb) as acct_char_descb -- 账户性质描述
    ,nvl(n.acct_attr_descb, o.acct_attr_descb) as acct_attr_descb -- 账户属性描述
    ,nvl(n.cross_bor_ibank_nostro_acct_id, o.cross_bor_ibank_nostro_acct_id) as cross_bor_ibank_nostro_acct_id -- 跨境同业往来账户编号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.acct_id <> n.acct_id
                or o.acct_name <> n.acct_name
                or o.tran_market_id <> n.tran_market_id
                or o.exchg_acct_id <> n.exchg_acct_id
                or o.curr_cd <> n.curr_cd
                or o.open_acct_bank_no <> n.open_acct_bank_no
                or o.open_acct_bank_name <> n.open_acct_bank_name
                or o.open_acct_dt <> n.open_acct_dt
                or o.cntpty_id <> n.cntpty_id
                or o.cntpty_name <> n.cntpty_name
                or o.intnal_cap_acct_num <> n.intnal_cap_acct_num
                or o.cap_acct_type_cd <> n.cap_acct_type_cd
                or o.intnal_acct_num <> n.intnal_acct_num
                or o.entry_org_id <> n.entry_org_id
                or o.intnal_acct_name <> n.intnal_acct_name
                or o.src_pay_int_ped_cd <> n.src_pay_int_ped_cd
                or o.pay_int_ped_corp_cd <> n.pay_int_ped_corp_cd
                or o.pay_int_ped_freq <> n.pay_int_ped_freq
                or o.int_rat_def_id <> n.int_rat_def_id
                or o.cap_type_cd <> n.cap_type_cd
                or o.pay_mon <> n.pay_mon
                or o.pay_days <> n.pay_days
                or o.int_rat <> n.int_rat
                or o.clos_acct_dt <> n.clos_acct_dt
                or o.prod_type_id <> n.prod_type_id
                or o.prod_cls_name <> n.prod_cls_name
                or o.subj_id <> n.subj_id
                or o.swift_cd <> n.swift_cd
                or o.belong_org_id <> n.belong_org_id
                or o.acct_char_descb <> n.acct_char_descb
                or o.acct_attr_descb <> n.acct_attr_descb
                or o.cross_bor_ibank_nostro_acct_id <> n.cross_bor_ibank_nostro_acct_id
            ) or (
                 case when (
                           n.agt_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.agt_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ext_cap_acct_ibmsf1_tm n
    full join ${iml_schema}.agt_ext_cap_acct_ibmsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_ext_cap_acct truncate partition for ('ibmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_ext_cap_acct exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.agt_ext_cap_acct_ibmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_ext_cap_acct drop subpartition p_ibmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ext_cap_acct to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_ext_cap_acct_ibmsf1_tm purge;
drop table ${iml_schema}.agt_ext_cap_acct_ibmsf1_ex purge;
drop table ${iml_schema}.agt_ext_cap_acct_ibmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ext_cap_acct', partname => 'p_ibmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);