/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_cmm_dep_cust_acct_info
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--alter table ${itl_schema}.itl_edw_cmm_dep_cust_acct_info drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_cmm_dep_cust_acct_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_cmm_dep_cust_acct_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_cmm_dep_cust_acct_info partition for (to_date('${batch_date}','yyyymmdd')) (
    lp_id -- 法人编号
    ,cust_acct_id -- 客户账户编号
    ,cust_acct_card_no -- 客户账户卡号
    ,cust_acct_name -- 客户账户名称
    ,cust_id -- 客户编号
    ,max_sub_acct_num -- 最大子户号
    ,std_prod_id -- 标准产品编号
    ,drawdown_way_cd -- 支取方式代码
    ,acct_status_cd -- 账户状态代码
    ,acct_type_cd -- 账户类型代码
    ,e_acct_type_cd -- 电子账户类型代码
    ,e_acct_status_cd -- 电子账户状态代码
    ,acct_drawdown_way_status -- 账户支取方式状态
    ,froz_status_cd -- 冻结状态代码
    ,stop_pay_status_cd -- 止付状态代码
    ,acpt_pay_status_cd -- 收付状态代码
    ,acct_usage_cd -- 账户用途代码
    ,vouch_kind_cd -- 凭证种类代码
    ,vouch_char_cd -- 凭证性质代码
    ,vouch_form_cd -- 凭证形式代码
    ,netw_vrfction_rest_cd -- 联网核查结果代码
    ,vrif_status_cd -- 核实状态代码
    ,sleep_acct_flg -- 睡眠户标志
    ,dormt_acct_flg -- 不动户标志
    ,privavy_acct_flg -- 隐私账户标志
    ,corp_acct_flg -- 对公账户标志
    ,bind_acct_flg -- 绑定账户标志
    ,fiscal_dep_flg -- 财政性存款标志
    ,acct_belong_org_id -- 账户所属机构编号
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_teller_id -- 开户柜员编号
    ,open_acct_chn_cd -- 开户渠道代码
    ,open_acct_flow_num -- 开户流水号
    ,open_acct_dt -- 开户日期
    ,open_acct_tm -- 开户时间
    ,close_acct_org_id -- 销户机构编号
    ,clos_acct_teller_id -- 销户柜员编号
    ,clos_acct_flow_num -- 销户流水号
    ,clos_acct_dt -- 销户日期
    ,clos_acct_tm -- 销户时间
    ,unvrif_rs_descb -- 无法核实原因描述
    ,disp_method_descb -- 处置方法描述
    ,tran_chn_status_cd -- 交易渠道状态代码
    ,CURR_CD --币种代码
    ,ACCT_ATTR_CD --账户属性代码
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(lp_id), ' ') as lp_id -- 法人编号
    ,nvl(trim(cust_acct_id), ' ') as cust_acct_id -- 客户账户编号
    ,nvl(trim(cust_acct_card_no), ' ') as cust_acct_card_no -- 客户账户卡号
    ,nvl(trim(cust_acct_name), ' ') as cust_acct_name -- 客户账户名称
    ,nvl(trim(cust_id), ' ') as cust_id -- 客户编号
    ,nvl(trim(max_sub_acct_num), ' ') as max_sub_acct_num -- 最大子户号
    ,nvl(trim(std_prod_id), ' ') as std_prod_id -- 标准产品编号
    ,nvl(trim(drawdown_way_cd), ' ') as drawdown_way_cd -- 支取方式代码
    ,nvl(trim(acct_status_cd), ' ') as acct_status_cd -- 账户状态代码
    ,nvl(trim(acct_type_cd), ' ') as acct_type_cd -- 账户类型代码
    ,nvl(trim(e_acct_type_cd), ' ') as e_acct_type_cd -- 电子账户类型代码
    ,nvl(trim(e_acct_status_cd), ' ') as e_acct_status_cd -- 电子账户状态代码
    ,nvl(trim(acct_drawdown_way_status), ' ') as acct_drawdown_way_status -- 账户支取方式状态
    ,nvl(trim(froz_status_cd), ' ') as froz_status_cd -- 冻结状态代码
    ,nvl(trim(stop_pay_status_cd), ' ') as stop_pay_status_cd -- 止付状态代码
    ,nvl(trim(acpt_pay_status_cd), ' ') as acpt_pay_status_cd -- 收付状态代码
    ,nvl(trim(acct_usage_cd), ' ') as acct_usage_cd -- 账户用途代码
    ,nvl(trim(vouch_kind_cd), ' ') as vouch_kind_cd -- 凭证种类代码
    ,nvl(trim(vouch_char_cd), ' ') as vouch_char_cd -- 凭证性质代码
    ,nvl(trim(vouch_form_cd), ' ') as vouch_form_cd -- 凭证形式代码
    ,nvl(trim(netw_vrfction_rest_cd), ' ') as netw_vrfction_rest_cd -- 联网核查结果代码
    ,nvl(trim(vrif_status_cd), ' ') as vrif_status_cd -- 核实状态代码
    ,nvl(trim(sleep_acct_flg), ' ') as sleep_acct_flg -- 睡眠户标志
    ,nvl(trim(dormt_acct_flg), ' ') as dormt_acct_flg -- 不动户标志
    ,nvl(trim(privavy_acct_flg), ' ') as privavy_acct_flg -- 隐私账户标志
    ,nvl(trim(corp_acct_flg), ' ') as corp_acct_flg -- 对公账户标志
    ,nvl(trim(bind_acct_flg), ' ') as bind_acct_flg -- 绑定账户标志
    ,nvl(trim(fiscal_dep_flg), ' ') as fiscal_dep_flg -- 财政性存款标志
    ,nvl(trim(acct_belong_org_id), ' ') as acct_belong_org_id -- 账户所属机构编号
    ,nvl(trim(open_acct_org_id), ' ') as open_acct_org_id -- 开户机构编号
    ,nvl(trim(open_acct_teller_id), ' ') as open_acct_teller_id -- 开户柜员编号
    ,nvl(trim(open_acct_chn_cd), ' ') as open_acct_chn_cd -- 开户渠道代码
    ,nvl(trim(open_acct_flow_num), ' ') as open_acct_flow_num -- 开户流水号
    ,nvl(open_acct_dt, to_date('00010101', 'yyyymmdd')) as open_acct_dt -- 开户日期
    ,nvl(open_acct_tm, to_timestamp('00010101', 'yyyymmdd')) as open_acct_tm -- 开户时间
    ,nvl(trim(close_acct_org_id), ' ') as close_acct_org_id -- 销户机构编号
    ,nvl(trim(clos_acct_teller_id), ' ') as clos_acct_teller_id -- 销户柜员编号
    ,nvl(trim(clos_acct_flow_num), ' ') as clos_acct_flow_num -- 销户流水号
    ,nvl(clos_acct_dt, to_date('00010101', 'yyyymmdd')) as clos_acct_dt -- 销户日期
    ,nvl(clos_acct_tm, to_timestamp('00010101', 'yyyymmdd')) as clos_acct_tm -- 销户时间
    ,nvl(trim(unvrif_rs_descb), ' ') as unvrif_rs_descb -- 无法核实原因描述
    ,nvl(trim(disp_method_descb), ' ') as disp_method_descb -- 处置方法描述
    ,nvl(trim(tran_chn_status_cd), ' ') as tran_chn_status_cd -- 交易渠道状态代码
    ,nvl(trim(CURR_CD), ' ') as CURR_CD -- 币种代码
    ,nvl(trim(ACCT_ATTR_CD), ' ') as ACCT_ATTR_CD -- 账户属性代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_cmm_dep_cust_acct_info 
where etl_dt = to_date('${batch_date}','yyyymmdd')
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_cmm_dep_cust_acct_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_cmm_dep_cust_acct_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);