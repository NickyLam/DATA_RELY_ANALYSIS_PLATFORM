/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ibank_apv_form_ibmsf1
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
drop table ${iml_schema}.agt_ibank_apv_form_ibmsf1_tm purge;
drop table ${iml_schema}.agt_ibank_apv_form_ibmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_ibank_apv_form add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_ibank_apv_form modify partition p_ibmsf1
    add subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ibank_apv_form_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ibank_apv_form partition for ('ibmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ibank_apv_form_ibmsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,apv_form_num -- 审批单号
    ,entr_tm -- 委托时间
    ,apv_status_cd -- 审批状态代码
    ,apv_lmt -- 审批额度
    ,actl_ocup_lmt -- 实际占用额度
    ,surp_aval_lmt -- 剩余可用额度
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,apv_vp_cnt -- 审批有效期数
    ,incremt_lmt_flg -- 增量限额标志
    ,apver_id -- 审批人编号
    ,apver_name -- 审批人名称
    ,rela_muti_tran_flg -- 关联比条交易标志
    ,wrtoff_lmt -- 注销额度
    ,apv_form_type_cd -- 审批单类型代码
    ,entr_bs_dir_cd -- 委托买卖方向代码
    ,entr_asset_type_cd -- 委托资产类型代码
    ,entr_asset_market_type_cd -- 委托资产市场类型代码
    ,entr_portf_unit_id -- 委托投组单元编号
    ,curr_cd -- 币种代码
    ,entr_yld_rat -- 委托收益率
    ,entr_price -- 委托价格
    ,distrtd_lmt -- 已分发额度
    ,not_distrt_lmt -- 未分发额度
    ,termnt_lmt -- 终止额度
    ,execed_lmt -- 已执行额度
    ,not_exec_lmt -- 未执行额度
    ,tran_seq_num -- 交易序号
    ,surp_apv_lmt -- 剩余审批额度
    ,ext_status_cd -- 外部状态代码
    ,task_step_seq_num -- 任务步骤序号
    ,revo_rtn_flg_cd -- 撤销退回标志代码
    ,surp_quot_lmt -- 剩余报价额度
    ,rela_apv_form_num -- 关联审批单号
    ,cm_attr_flg -- 主从属性标志
    ,rela_attr_flg -- 关联属性标志
    ,up_down_cd -- 上下行代码
    ,match_mode_cd -- 匹配模式代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ibank_apv_form
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_ibank_apv_form_ibmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_ibank_apv_form partition for ('ibmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ibms_ttrd_otc_order-
insert into ${iml_schema}.agt_ibank_apv_form_ibmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,apv_form_num -- 审批单号
    ,entr_tm -- 委托时间
    ,apv_status_cd -- 审批状态代码
    ,apv_lmt -- 审批额度
    ,actl_ocup_lmt -- 实际占用额度
    ,surp_aval_lmt -- 剩余可用额度
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,apv_vp_cnt -- 审批有效期数
    ,incremt_lmt_flg -- 增量限额标志
    ,apver_id -- 审批人编号
    ,apver_name -- 审批人名称
    ,rela_muti_tran_flg -- 关联比条交易标志
    ,wrtoff_lmt -- 注销额度
    ,apv_form_type_cd -- 审批单类型代码
    ,entr_bs_dir_cd -- 委托买卖方向代码
    ,entr_asset_type_cd -- 委托资产类型代码
    ,entr_asset_market_type_cd -- 委托资产市场类型代码
    ,entr_portf_unit_id -- 委托投组单元编号
    ,curr_cd -- 币种代码
    ,entr_yld_rat -- 委托收益率
    ,entr_price -- 委托价格
    ,distrtd_lmt -- 已分发额度
    ,not_distrt_lmt -- 未分发额度
    ,termnt_lmt -- 终止额度
    ,execed_lmt -- 已执行额度
    ,not_exec_lmt -- 未执行额度
    ,tran_seq_num -- 交易序号
    ,surp_apv_lmt -- 剩余审批额度
    ,ext_status_cd -- 外部状态代码
    ,task_step_seq_num -- 任务步骤序号
    ,revo_rtn_flg_cd -- 撤销退回标志代码
    ,surp_quot_lmt -- 剩余报价额度
    ,rela_apv_form_num -- 关联审批单号
    ,cm_attr_flg -- 主从属性标志
    ,rela_attr_flg -- 关联属性标志
    ,up_down_cd -- 上下行代码
    ,match_mode_cd -- 匹配模式代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '224107'||P1.ORD_ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ORD_ID -- 审批单号
    ,to_timestamp(P1.ORDDATE||' '||p1.ordtime,'yyyy-mm-dd hh24:mi:ss.ff6') -- 委托时间
    ,CASE WHEN R3.target_cd_val IS NOT NULL THEN R3.target_cd_val ELSE '@'||TO_CHAR(P1.ORDSTATUS) END -- 审批状态代码
    ,P1.TOTAL_AMOUNT -- 审批额度
    ,P1.USED_AMOUNT -- 实际占用额度
    ,P1.REMAIN_AMOUNT -- 剩余可用额度
    ,${iml_schema}.DATEFORMAT_MIN(P1.BEG_DATE) -- 生效日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.END_DATE) -- 失效日期
    ,P1.EFFECTDAYS -- 审批有效期数
    ,P1.ISINCLIMIT -- 增量限额标志
    ,P1.ORD_USER_ID -- 审批人编号
    ,P1.ORD_USER -- 审批人名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL WHEN TRIM(P1.MUTI_TRADE_REF) IS NULL THEN '0' ELSE '@'||TRIM(P1.MUTI_TRADE_REF) END -- 关联比条交易标志
    ,P1.CANCEL_AMOUNT -- 注销额度
    ,P1.ORDER_TYPE -- 审批单类型代码
    ,P1.DIRECTION -- 委托买卖方向代码
    ,P1.A_TYPE -- 委托资产类型代码
    ,P1.M_TYPE -- 委托资产市场类型代码
    ,P1.WMPS_UNIT_ID -- 委托投组单元编号
    ,P1.CURRENCY -- 币种代码
    ,P1.LIMIT_YTM -- 委托收益率
    ,P1.LIMIT_PRICE -- 委托价格
    ,P1.DISP_AMOUNT -- 已分发额度
    ,P1.UNDISP_AMOUNT -- 未分发额度
    ,P1.ABORT_AMOUNT -- 终止额度
    ,P1.EXEC_AMOUNT -- 已执行额度
    ,P1.UNEXEC_AMOUNT -- 未执行额度
    ,P1.SYSORDID -- 交易序号
    ,P1.REMAIN_AMOUNT4CONFIRM -- 剩余审批额度
    ,CASE WHEN R2.target_cd_val IS NOT NULL THEN R2.target_cd_val ELSE '@'||TO_CHAR(P1.OUT_STATE) END -- 外部状态代码
    ,P1.TASK_ORDINAL -- 任务步骤序号
    ,P1.CANCELORBACK -- 撤销退回标志代码
    ,P1.REMAIN_AMOUNT4QUOTE -- 剩余报价额度
    ,P1.RELATION_ORD_ID -- 关联审批单号
    ,P1.CM_ATTR_MASTER -- 主从属性标志
    ,P1.CM_ATTR_RELATION -- 关联属性标志
    ,P1.IS_FOR_CFETS -- 上下行代码
    ,P1.MATCH_MODE -- 匹配模式代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_otc_order' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_otc_order p1
    left join ${iml_schema}.ref_pub_cd_map r3 on TO_CHAR(P1.ORDSTATUS) = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IBMS'
        AND R3.SRC_TAB_EN_NAME= 'IBMS_TTRD_OTC_ORDER'
        AND R3.SRC_FIELD_EN_NAME= 'ORDSTATUS'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_IBANK_APV_FORM'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'APV_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.MUTI_TRADE_REF = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IBMS'
        AND R1.SRC_TAB_EN_NAME= 'IBMS_TTRD_OTC_ORDER'
        AND R1.SRC_FIELD_EN_NAME= 'MUTI_TRADE_REF'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_IBANK_APV_FORM'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'RELA_MUTI_TRAN_FLG'
    left join ${iml_schema}.ref_pub_cd_map r2 on TO_CHAR(P1.OUT_STATE) = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IBMS'
        AND R2.SRC_TAB_EN_NAME= 'IBMS_TTRD_OTC_ORDER'
        AND R2.SRC_FIELD_EN_NAME= 'OUT_STATE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_IBANK_APV_FORM'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'EXT_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_ibank_apv_form_ibmsf1_tm 
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
insert /*+ append */ into ${iml_schema}.agt_ibank_apv_form_ibmsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,apv_form_num -- 审批单号
    ,entr_tm -- 委托时间
    ,apv_status_cd -- 审批状态代码
    ,apv_lmt -- 审批额度
    ,actl_ocup_lmt -- 实际占用额度
    ,surp_aval_lmt -- 剩余可用额度
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,apv_vp_cnt -- 审批有效期数
    ,incremt_lmt_flg -- 增量限额标志
    ,apver_id -- 审批人编号
    ,apver_name -- 审批人名称
    ,rela_muti_tran_flg -- 关联比条交易标志
    ,wrtoff_lmt -- 注销额度
    ,apv_form_type_cd -- 审批单类型代码
    ,entr_bs_dir_cd -- 委托买卖方向代码
    ,entr_asset_type_cd -- 委托资产类型代码
    ,entr_asset_market_type_cd -- 委托资产市场类型代码
    ,entr_portf_unit_id -- 委托投组单元编号
    ,curr_cd -- 币种代码
    ,entr_yld_rat -- 委托收益率
    ,entr_price -- 委托价格
    ,distrtd_lmt -- 已分发额度
    ,not_distrt_lmt -- 未分发额度
    ,termnt_lmt -- 终止额度
    ,execed_lmt -- 已执行额度
    ,not_exec_lmt -- 未执行额度
    ,tran_seq_num -- 交易序号
    ,surp_apv_lmt -- 剩余审批额度
    ,ext_status_cd -- 外部状态代码
    ,task_step_seq_num -- 任务步骤序号
    ,revo_rtn_flg_cd -- 撤销退回标志代码
    ,surp_quot_lmt -- 剩余报价额度
    ,rela_apv_form_num -- 关联审批单号
    ,cm_attr_flg -- 主从属性标志
    ,rela_attr_flg -- 关联属性标志
    ,up_down_cd -- 上下行代码
    ,match_mode_cd -- 匹配模式代码
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
    ,nvl(n.apv_form_num, o.apv_form_num) as apv_form_num -- 审批单号
    ,nvl(n.entr_tm, o.entr_tm) as entr_tm -- 委托时间
    ,nvl(n.apv_status_cd, o.apv_status_cd) as apv_status_cd -- 审批状态代码
    ,nvl(n.apv_lmt, o.apv_lmt) as apv_lmt -- 审批额度
    ,nvl(n.actl_ocup_lmt, o.actl_ocup_lmt) as actl_ocup_lmt -- 实际占用额度
    ,nvl(n.surp_aval_lmt, o.surp_aval_lmt) as surp_aval_lmt -- 剩余可用额度
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.apv_vp_cnt, o.apv_vp_cnt) as apv_vp_cnt -- 审批有效期数
    ,nvl(n.incremt_lmt_flg, o.incremt_lmt_flg) as incremt_lmt_flg -- 增量限额标志
    ,nvl(n.apver_id, o.apver_id) as apver_id -- 审批人编号
    ,nvl(n.apver_name, o.apver_name) as apver_name -- 审批人名称
    ,nvl(n.rela_muti_tran_flg, o.rela_muti_tran_flg) as rela_muti_tran_flg -- 关联比条交易标志
    ,nvl(n.wrtoff_lmt, o.wrtoff_lmt) as wrtoff_lmt -- 注销额度
    ,nvl(n.apv_form_type_cd, o.apv_form_type_cd) as apv_form_type_cd -- 审批单类型代码
    ,nvl(n.entr_bs_dir_cd, o.entr_bs_dir_cd) as entr_bs_dir_cd -- 委托买卖方向代码
    ,nvl(n.entr_asset_type_cd, o.entr_asset_type_cd) as entr_asset_type_cd -- 委托资产类型代码
    ,nvl(n.entr_asset_market_type_cd, o.entr_asset_market_type_cd) as entr_asset_market_type_cd -- 委托资产市场类型代码
    ,nvl(n.entr_portf_unit_id, o.entr_portf_unit_id) as entr_portf_unit_id -- 委托投组单元编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.entr_yld_rat, o.entr_yld_rat) as entr_yld_rat -- 委托收益率
    ,nvl(n.entr_price, o.entr_price) as entr_price -- 委托价格
    ,nvl(n.distrtd_lmt, o.distrtd_lmt) as distrtd_lmt -- 已分发额度
    ,nvl(n.not_distrt_lmt, o.not_distrt_lmt) as not_distrt_lmt -- 未分发额度
    ,nvl(n.termnt_lmt, o.termnt_lmt) as termnt_lmt -- 终止额度
    ,nvl(n.execed_lmt, o.execed_lmt) as execed_lmt -- 已执行额度
    ,nvl(n.not_exec_lmt, o.not_exec_lmt) as not_exec_lmt -- 未执行额度
    ,nvl(n.tran_seq_num, o.tran_seq_num) as tran_seq_num -- 交易序号
    ,nvl(n.surp_apv_lmt, o.surp_apv_lmt) as surp_apv_lmt -- 剩余审批额度
    ,nvl(n.ext_status_cd, o.ext_status_cd) as ext_status_cd -- 外部状态代码
    ,nvl(n.task_step_seq_num, o.task_step_seq_num) as task_step_seq_num -- 任务步骤序号
    ,nvl(n.revo_rtn_flg_cd, o.revo_rtn_flg_cd) as revo_rtn_flg_cd -- 撤销退回标志代码
    ,nvl(n.surp_quot_lmt, o.surp_quot_lmt) as surp_quot_lmt -- 剩余报价额度
    ,nvl(n.rela_apv_form_num, o.rela_apv_form_num) as rela_apv_form_num -- 关联审批单号
    ,nvl(n.cm_attr_flg, o.cm_attr_flg) as cm_attr_flg -- 主从属性标志
    ,nvl(n.rela_attr_flg, o.rela_attr_flg) as rela_attr_flg -- 关联属性标志
    ,nvl(n.up_down_cd, o.up_down_cd) as up_down_cd -- 上下行代码
    ,nvl(n.match_mode_cd, o.match_mode_cd) as match_mode_cd -- 匹配模式代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.apv_form_num <> n.apv_form_num
                or o.entr_tm <> n.entr_tm
                or o.apv_status_cd <> n.apv_status_cd
                or o.apv_lmt <> n.apv_lmt
                or o.actl_ocup_lmt <> n.actl_ocup_lmt
                or o.surp_aval_lmt <> n.surp_aval_lmt
                or o.effect_dt <> n.effect_dt
                or o.invalid_dt <> n.invalid_dt
                or o.apv_vp_cnt <> n.apv_vp_cnt
                or o.incremt_lmt_flg <> n.incremt_lmt_flg
                or o.apver_id <> n.apver_id
                or o.apver_name <> n.apver_name
                or o.rela_muti_tran_flg <> n.rela_muti_tran_flg
                or o.wrtoff_lmt <> n.wrtoff_lmt
                or o.apv_form_type_cd <> n.apv_form_type_cd
                or o.entr_bs_dir_cd <> n.entr_bs_dir_cd
                or o.entr_asset_type_cd <> n.entr_asset_type_cd
                or o.entr_asset_market_type_cd <> n.entr_asset_market_type_cd
                or o.entr_portf_unit_id <> n.entr_portf_unit_id
                or o.curr_cd <> n.curr_cd
                or o.entr_yld_rat <> n.entr_yld_rat
                or o.entr_price <> n.entr_price
                or o.distrtd_lmt <> n.distrtd_lmt
                or o.not_distrt_lmt <> n.not_distrt_lmt
                or o.termnt_lmt <> n.termnt_lmt
                or o.execed_lmt <> n.execed_lmt
                or o.not_exec_lmt <> n.not_exec_lmt
                or o.tran_seq_num <> n.tran_seq_num
                or o.surp_apv_lmt <> n.surp_apv_lmt
                or o.ext_status_cd <> n.ext_status_cd
                or o.task_step_seq_num <> n.task_step_seq_num
                or o.revo_rtn_flg_cd <> n.revo_rtn_flg_cd
                or o.surp_quot_lmt <> n.surp_quot_lmt
                or o.rela_apv_form_num <> n.rela_apv_form_num
                or o.cm_attr_flg <> n.cm_attr_flg
                or o.rela_attr_flg <> n.rela_attr_flg
                or o.up_down_cd <> n.up_down_cd
                or o.match_mode_cd <> n.match_mode_cd
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
from ${iml_schema}.agt_ibank_apv_form_ibmsf1_tm n
    full join ${iml_schema}.agt_ibank_apv_form_ibmsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_ibank_apv_form truncate partition for ('ibmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_ibank_apv_form exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.agt_ibank_apv_form_ibmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_ibank_apv_form drop subpartition p_ibmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ibank_apv_form to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_ibank_apv_form_ibmsf1_tm purge;
drop table ${iml_schema}.agt_ibank_apv_form_ibmsf1_ex purge;
drop table ${iml_schema}.agt_ibank_apv_form_ibmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ibank_apv_form', partname => 'p_ibmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);