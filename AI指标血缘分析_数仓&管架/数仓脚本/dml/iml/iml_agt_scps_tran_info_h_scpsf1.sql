/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_scps_tran_info_h_scpsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_scps_tran_info_h add partition p_scpsf1 values ('scpsf1')(
        subpartition p_scpsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_scpsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_scps_tran_info_h_scpsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_scps_tran_info_h partition for ('scpsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_scps_tran_info_h_scpsf1_tm purge;
drop table ${iml_schema}.agt_scps_tran_info_h_scpsf1_op purge;
drop table ${iml_schema}.agt_scps_tran_info_h_scpsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_scps_tran_info_h_scpsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,task_no -- 任务号
    ,bank_no -- 银行行号
    ,sys_id -- 系统编号
    ,sub_task_no -- 子任务号
    ,init_task_no -- 原任务号
    ,task_status_cd -- 任务状态代码
    ,payment_flow_num -- 前台流水号
    ,ova_flow_num -- 全局流水号
    ,tran_code -- 交易码
    ,bus_scene_id -- 业务场景编号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,chn_id -- 渠道编号
    ,blip_flow_num -- 影像流水号
    ,ghb_acct_id -- 本行账户编号
    ,ghb_acct_name -- 本行账户名称
    ,invalid_tm -- 失效时间
    ,invalid_dt -- 失效日期
    ,refuse_rs_descb -- 拒绝原因描述
    ,err_idtfy_rs_descb -- 差错认定原因描述
    ,opera_mode_cd -- 作业模式代码
    ,opera_status_cd -- 作业状态代码
    ,remark -- 备注
    ,bus_init_teller_id -- 业务发起柜员编号
    ,bus_init_director_teller_id -- 业务发起主管柜员编号
    ,bus_init_org_id -- 业务发起机构编号
    ,oper_status_cd -- 操作状态代码
    ,bus_gen_cd -- 业务大类代码
    ,prob_node_cd -- 问题节点代码
    ,prob_cls_cd -- 问题分类代码
    ,prob_init_dt -- 问题发起日期
    ,prob_init_tm -- 问题发起时间
    ,prob_rs -- 问题原因
    ,prob_init_teller_id -- 问题发起柜员编号
    ,issue_dt -- 发布日期
    ,issue_tm -- 发布时间
    ,check_idtfy_rest_cd -- 审核认定结果代码
    ,check_remark -- 审核备注
    ,check_idtfy_rs -- 审核认定原因
    ,authoriz_diret_teller_id -- 授权主管柜员编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_scps_tran_info_h partition for ('scpsf1')
where 0=1
;

create table ${iml_schema}.agt_scps_tran_info_h_scpsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_scps_tran_info_h partition for ('scpsf1') where 0=1;

create table ${iml_schema}.agt_scps_tran_info_h_scpsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_scps_tran_info_h partition for ('scpsf1') where 0=1;

-- 3.1 get new data into table
-- scps_bp_flowtask_refuse_tb-1
insert into ${iml_schema}.agt_scps_tran_info_h_scpsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,task_no -- 任务号
    ,bank_no -- 银行行号
    ,sys_id -- 系统编号
    ,sub_task_no -- 子任务号
    ,init_task_no -- 原任务号
    ,task_status_cd -- 任务状态代码
    ,payment_flow_num -- 前台流水号
    ,ova_flow_num -- 全局流水号
    ,tran_code -- 交易码
    ,bus_scene_id -- 业务场景编号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,chn_id -- 渠道编号
    ,blip_flow_num -- 影像流水号
    ,ghb_acct_id -- 本行账户编号
    ,ghb_acct_name -- 本行账户名称
    ,invalid_tm -- 失效时间
    ,invalid_dt -- 失效日期
    ,refuse_rs_descb -- 拒绝原因描述
    ,err_idtfy_rs_descb -- 差错认定原因描述
    ,opera_mode_cd -- 作业模式代码
    ,opera_status_cd -- 作业状态代码
    ,remark -- 备注
    ,bus_init_teller_id -- 业务发起柜员编号
    ,bus_init_director_teller_id -- 业务发起主管柜员编号
    ,bus_init_org_id -- 业务发起机构编号
    ,oper_status_cd -- 操作状态代码
    ,bus_gen_cd -- 业务大类代码
    ,prob_node_cd -- 问题节点代码
    ,prob_cls_cd -- 问题分类代码
    ,prob_init_dt -- 问题发起日期
    ,prob_init_tm -- 问题发起时间
    ,prob_rs -- 问题原因
    ,prob_init_teller_id -- 问题发起柜员编号
    ,issue_dt -- 发布日期
    ,issue_tm -- 发布时间
    ,check_idtfy_rest_cd -- 审核认定结果代码
    ,check_remark -- 审核备注
    ,check_idtfy_rs -- 审核认定原因
    ,authoriz_diret_teller_id -- 授权主管柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300022'||P1.TASK_ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.TASK_ID -- 任务号
    ,P1.BANK_NO -- 银行行号
    ,P1.SYSTEM_NO -- 系统编号
    ,P1.SUB_TASK_ID -- 子任务号
    ,P1.Y_TASK_ID -- 原任务号
    ,nvl(trim(P1.TASK_STATE),'-') -- 任务状态代码
    ,P1.BRANCH_SERIAL -- 前台流水号
    ,P1.GLOB_SEQ_NO -- 全局流水号
    ,P1.TRADECODE -- 交易码
    ,P1.SCENE_CODE -- 业务场景编号
    ,${iml_schema}.dateformat_min(P1.TRANS_DATE) -- 交易日期
    ,${iml_schema}.timeformat_min(trim(P1.TRANS_DATE)||trim(P1.TRANS_TIME)) -- 交易时间
    ,nvl(trim(P1.CHANNEL_ID),'-') -- 渠道编号
    ,P1.DOC_ID -- 影像流水号
    ,P1.ACCOUNT_NO -- 本行账户编号
    ,P1.ACCOUNT_NAME -- 本行账户名称
    ,${iml_schema}.timeformat_max2(trim(P1.END_DATE)||trim(P1.END_TIME)) -- 失效时间
    ,${iml_schema}.dateformat_max2(P1.END_DATE) -- 失效日期
    ,P1.REFUSAL_REASON -- 拒绝原因描述
    ,P1.REASON_OF_ERROR -- 差错认定原因描述
    ,nvl(trim(P1.MODE_TYPE),'-') -- 作业模式代码
    ,nvl(trim(P1.ERROR_STATUS),'-') -- 作业状态代码
    ,P1.REMARKS -- 备注
    ,P1.BEGIN_USERNO -- 业务发起柜员编号
    ,P1.BEGIN_CHARGE_ID -- 业务发起主管柜员编号
    ,P1.BEGIN_ORGNO -- 业务发起机构编号
    ,nvl(trim(P1.OPERATION_STATUS),'-') -- 操作状态代码
    ,nvl(trim(P1.TRANS_TYPE),'-') -- 业务大类代码
    ,nvl(trim(P1.QUESTION_NODE),'-') -- 问题节点代码
    ,nvl(trim(P1.PROBLEM_CLASS),'-') -- 问题分类代码
    ,${iml_schema}.dateformat_min(P1.QUESTION_BEGIN_DATE) -- 问题发起日期
    ,${iml_schema}.timeformat_min(trim(P1.QUESTION_BEGIN_DATE)||trim(P1.QUESTION_BEGIN_TIME)) -- 问题发起时间
    ,P1.QUESTION_RENSON -- 问题原因
    ,P1.QUESTION_BEGIN_USER_NO -- 问题发起柜员编号
    ,${iml_schema}.dateformat_min(P1.ISSUE_DATE) -- 发布日期
    ,${iml_schema}.timeformat_min(trim(P1.ISSUE_DATE)||trim(P1.ISSUE_TIME)) -- 发布时间
    ,nvl(trim(P1.APPROV_RESULTS),'-') -- 审核认定结果代码
    ,P1.APPROV_REMARKS -- 审核备注
    ,P1.APPROV_REASON -- 审核认定原因
    ,P1.SQZG_USER -- 授权主管柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'scps_bp_flowtask_refuse_tb' -- 源表名称
    ,'scpsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.scps_bp_flowtask_refuse_tb p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_scps_tran_info_h_scpsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,task_no
  	                                        ,bank_no
  	                                        ,sys_id
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_scps_tran_info_h_scpsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,task_no -- 任务号
    ,bank_no -- 银行行号
    ,sys_id -- 系统编号
    ,sub_task_no -- 子任务号
    ,init_task_no -- 原任务号
    ,task_status_cd -- 任务状态代码
    ,payment_flow_num -- 前台流水号
    ,ova_flow_num -- 全局流水号
    ,tran_code -- 交易码
    ,bus_scene_id -- 业务场景编号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,chn_id -- 渠道编号
    ,blip_flow_num -- 影像流水号
    ,ghb_acct_id -- 本行账户编号
    ,ghb_acct_name -- 本行账户名称
    ,invalid_tm -- 失效时间
    ,invalid_dt -- 失效日期
    ,refuse_rs_descb -- 拒绝原因描述
    ,err_idtfy_rs_descb -- 差错认定原因描述
    ,opera_mode_cd -- 作业模式代码
    ,opera_status_cd -- 作业状态代码
    ,remark -- 备注
    ,bus_init_teller_id -- 业务发起柜员编号
    ,bus_init_director_teller_id -- 业务发起主管柜员编号
    ,bus_init_org_id -- 业务发起机构编号
    ,oper_status_cd -- 操作状态代码
    ,bus_gen_cd -- 业务大类代码
    ,prob_node_cd -- 问题节点代码
    ,prob_cls_cd -- 问题分类代码
    ,prob_init_dt -- 问题发起日期
    ,prob_init_tm -- 问题发起时间
    ,prob_rs -- 问题原因
    ,prob_init_teller_id -- 问题发起柜员编号
    ,issue_dt -- 发布日期
    ,issue_tm -- 发布时间
    ,check_idtfy_rest_cd -- 审核认定结果代码
    ,check_remark -- 审核备注
    ,check_idtfy_rs -- 审核认定原因
    ,authoriz_diret_teller_id -- 授权主管柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_scps_tran_info_h_scpsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,task_no -- 任务号
    ,bank_no -- 银行行号
    ,sys_id -- 系统编号
    ,sub_task_no -- 子任务号
    ,init_task_no -- 原任务号
    ,task_status_cd -- 任务状态代码
    ,payment_flow_num -- 前台流水号
    ,ova_flow_num -- 全局流水号
    ,tran_code -- 交易码
    ,bus_scene_id -- 业务场景编号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,chn_id -- 渠道编号
    ,blip_flow_num -- 影像流水号
    ,ghb_acct_id -- 本行账户编号
    ,ghb_acct_name -- 本行账户名称
    ,invalid_tm -- 失效时间
    ,invalid_dt -- 失效日期
    ,refuse_rs_descb -- 拒绝原因描述
    ,err_idtfy_rs_descb -- 差错认定原因描述
    ,opera_mode_cd -- 作业模式代码
    ,opera_status_cd -- 作业状态代码
    ,remark -- 备注
    ,bus_init_teller_id -- 业务发起柜员编号
    ,bus_init_director_teller_id -- 业务发起主管柜员编号
    ,bus_init_org_id -- 业务发起机构编号
    ,oper_status_cd -- 操作状态代码
    ,bus_gen_cd -- 业务大类代码
    ,prob_node_cd -- 问题节点代码
    ,prob_cls_cd -- 问题分类代码
    ,prob_init_dt -- 问题发起日期
    ,prob_init_tm -- 问题发起时间
    ,prob_rs -- 问题原因
    ,prob_init_teller_id -- 问题发起柜员编号
    ,issue_dt -- 发布日期
    ,issue_tm -- 发布时间
    ,check_idtfy_rest_cd -- 审核认定结果代码
    ,check_remark -- 审核备注
    ,check_idtfy_rs -- 审核认定原因
    ,authoriz_diret_teller_id -- 授权主管柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.task_no, o.task_no) as task_no -- 任务号
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 银行行号
    ,nvl(n.sys_id, o.sys_id) as sys_id -- 系统编号
    ,nvl(n.sub_task_no, o.sub_task_no) as sub_task_no -- 子任务号
    ,nvl(n.init_task_no, o.init_task_no) as init_task_no -- 原任务号
    ,nvl(n.task_status_cd, o.task_status_cd) as task_status_cd -- 任务状态代码
    ,nvl(n.payment_flow_num, o.payment_flow_num) as payment_flow_num -- 前台流水号
    ,nvl(n.ova_flow_num, o.ova_flow_num) as ova_flow_num -- 全局流水号
    ,nvl(n.tran_code, o.tran_code) as tran_code -- 交易码
    ,nvl(n.bus_scene_id, o.bus_scene_id) as bus_scene_id -- 业务场景编号
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.chn_id, o.chn_id) as chn_id -- 渠道编号
    ,nvl(n.blip_flow_num, o.blip_flow_num) as blip_flow_num -- 影像流水号
    ,nvl(n.ghb_acct_id, o.ghb_acct_id) as ghb_acct_id -- 本行账户编号
    ,nvl(n.ghb_acct_name, o.ghb_acct_name) as ghb_acct_name -- 本行账户名称
    ,nvl(n.invalid_tm, o.invalid_tm) as invalid_tm -- 失效时间
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.refuse_rs_descb, o.refuse_rs_descb) as refuse_rs_descb -- 拒绝原因描述
    ,nvl(n.err_idtfy_rs_descb, o.err_idtfy_rs_descb) as err_idtfy_rs_descb -- 差错认定原因描述
    ,nvl(n.opera_mode_cd, o.opera_mode_cd) as opera_mode_cd -- 作业模式代码
    ,nvl(n.opera_status_cd, o.opera_status_cd) as opera_status_cd -- 作业状态代码
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.bus_init_teller_id, o.bus_init_teller_id) as bus_init_teller_id -- 业务发起柜员编号
    ,nvl(n.bus_init_director_teller_id, o.bus_init_director_teller_id) as bus_init_director_teller_id -- 业务发起主管柜员编号
    ,nvl(n.bus_init_org_id, o.bus_init_org_id) as bus_init_org_id -- 业务发起机构编号
    ,nvl(n.oper_status_cd, o.oper_status_cd) as oper_status_cd -- 操作状态代码
    ,nvl(n.bus_gen_cd, o.bus_gen_cd) as bus_gen_cd -- 业务大类代码
    ,nvl(n.prob_node_cd, o.prob_node_cd) as prob_node_cd -- 问题节点代码
    ,nvl(n.prob_cls_cd, o.prob_cls_cd) as prob_cls_cd -- 问题分类代码
    ,nvl(n.prob_init_dt, o.prob_init_dt) as prob_init_dt -- 问题发起日期
    ,nvl(n.prob_init_tm, o.prob_init_tm) as prob_init_tm -- 问题发起时间
    ,nvl(n.prob_rs, o.prob_rs) as prob_rs -- 问题原因
    ,nvl(n.prob_init_teller_id, o.prob_init_teller_id) as prob_init_teller_id -- 问题发起柜员编号
    ,nvl(n.issue_dt, o.issue_dt) as issue_dt -- 发布日期
    ,nvl(n.issue_tm, o.issue_tm) as issue_tm -- 发布时间
    ,nvl(n.check_idtfy_rest_cd, o.check_idtfy_rest_cd) as check_idtfy_rest_cd -- 审核认定结果代码
    ,nvl(n.check_remark, o.check_remark) as check_remark -- 审核备注
    ,nvl(n.check_idtfy_rs, o.check_idtfy_rs) as check_idtfy_rs -- 审核认定原因
    ,nvl(n.authoriz_diret_teller_id, o.authoriz_diret_teller_id) as authoriz_diret_teller_id -- 授权主管柜员编号
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.task_no is null
            and n.bank_no is null
            and n.sys_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.task_no is null
            and n.bank_no is null
            and n.sys_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.task_no is null
            and n.bank_no is null
            and n.sys_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_scps_tran_info_h_scpsf1_tm n
    full join (select * from ${iml_schema}.agt_scps_tran_info_h_scpsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.task_no = n.task_no
            and o.bank_no = n.bank_no
            and o.sys_id = n.sys_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.task_no is null
        and o.bank_no is null
        and o.sys_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.task_no is null
        and n.bank_no is null
        and n.sys_id is null
    )
    or (
        o.sub_task_no <> n.sub_task_no
        or o.init_task_no <> n.init_task_no
        or o.task_status_cd <> n.task_status_cd
        or o.payment_flow_num <> n.payment_flow_num
        or o.ova_flow_num <> n.ova_flow_num
        or o.tran_code <> n.tran_code
        or o.bus_scene_id <> n.bus_scene_id
        or o.tran_dt <> n.tran_dt
        or o.tran_tm <> n.tran_tm
        or o.chn_id <> n.chn_id
        or o.blip_flow_num <> n.blip_flow_num
        or o.ghb_acct_id <> n.ghb_acct_id
        or o.ghb_acct_name <> n.ghb_acct_name
        or o.invalid_tm <> n.invalid_tm
        or o.invalid_dt <> n.invalid_dt
        or o.refuse_rs_descb <> n.refuse_rs_descb
        or o.err_idtfy_rs_descb <> n.err_idtfy_rs_descb
        or o.opera_mode_cd <> n.opera_mode_cd
        or o.opera_status_cd <> n.opera_status_cd
        or o.remark <> n.remark
        or o.bus_init_teller_id <> n.bus_init_teller_id
        or o.bus_init_director_teller_id <> n.bus_init_director_teller_id
        or o.bus_init_org_id <> n.bus_init_org_id
        or o.oper_status_cd <> n.oper_status_cd
        or o.bus_gen_cd <> n.bus_gen_cd
        or o.prob_node_cd <> n.prob_node_cd
        or o.prob_cls_cd <> n.prob_cls_cd
        or o.prob_init_dt <> n.prob_init_dt
        or o.prob_init_tm <> n.prob_init_tm
        or o.prob_rs <> n.prob_rs
        or o.prob_init_teller_id <> n.prob_init_teller_id
        or o.issue_dt <> n.issue_dt
        or o.issue_tm <> n.issue_tm
        or o.check_idtfy_rest_cd <> n.check_idtfy_rest_cd
        or o.check_remark <> n.check_remark
        or o.check_idtfy_rs <> n.check_idtfy_rs
        or o.authoriz_diret_teller_id <> n.authoriz_diret_teller_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_scps_tran_info_h_scpsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,task_no -- 任务号
    ,bank_no -- 银行行号
    ,sys_id -- 系统编号
    ,sub_task_no -- 子任务号
    ,init_task_no -- 原任务号
    ,task_status_cd -- 任务状态代码
    ,payment_flow_num -- 前台流水号
    ,ova_flow_num -- 全局流水号
    ,tran_code -- 交易码
    ,bus_scene_id -- 业务场景编号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,chn_id -- 渠道编号
    ,blip_flow_num -- 影像流水号
    ,ghb_acct_id -- 本行账户编号
    ,ghb_acct_name -- 本行账户名称
    ,invalid_tm -- 失效时间
    ,invalid_dt -- 失效日期
    ,refuse_rs_descb -- 拒绝原因描述
    ,err_idtfy_rs_descb -- 差错认定原因描述
    ,opera_mode_cd -- 作业模式代码
    ,opera_status_cd -- 作业状态代码
    ,remark -- 备注
    ,bus_init_teller_id -- 业务发起柜员编号
    ,bus_init_director_teller_id -- 业务发起主管柜员编号
    ,bus_init_org_id -- 业务发起机构编号
    ,oper_status_cd -- 操作状态代码
    ,bus_gen_cd -- 业务大类代码
    ,prob_node_cd -- 问题节点代码
    ,prob_cls_cd -- 问题分类代码
    ,prob_init_dt -- 问题发起日期
    ,prob_init_tm -- 问题发起时间
    ,prob_rs -- 问题原因
    ,prob_init_teller_id -- 问题发起柜员编号
    ,issue_dt -- 发布日期
    ,issue_tm -- 发布时间
    ,check_idtfy_rest_cd -- 审核认定结果代码
    ,check_remark -- 审核备注
    ,check_idtfy_rs -- 审核认定原因
    ,authoriz_diret_teller_id -- 授权主管柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_scps_tran_info_h_scpsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,task_no -- 任务号
    ,bank_no -- 银行行号
    ,sys_id -- 系统编号
    ,sub_task_no -- 子任务号
    ,init_task_no -- 原任务号
    ,task_status_cd -- 任务状态代码
    ,payment_flow_num -- 前台流水号
    ,ova_flow_num -- 全局流水号
    ,tran_code -- 交易码
    ,bus_scene_id -- 业务场景编号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,chn_id -- 渠道编号
    ,blip_flow_num -- 影像流水号
    ,ghb_acct_id -- 本行账户编号
    ,ghb_acct_name -- 本行账户名称
    ,invalid_tm -- 失效时间
    ,invalid_dt -- 失效日期
    ,refuse_rs_descb -- 拒绝原因描述
    ,err_idtfy_rs_descb -- 差错认定原因描述
    ,opera_mode_cd -- 作业模式代码
    ,opera_status_cd -- 作业状态代码
    ,remark -- 备注
    ,bus_init_teller_id -- 业务发起柜员编号
    ,bus_init_director_teller_id -- 业务发起主管柜员编号
    ,bus_init_org_id -- 业务发起机构编号
    ,oper_status_cd -- 操作状态代码
    ,bus_gen_cd -- 业务大类代码
    ,prob_node_cd -- 问题节点代码
    ,prob_cls_cd -- 问题分类代码
    ,prob_init_dt -- 问题发起日期
    ,prob_init_tm -- 问题发起时间
    ,prob_rs -- 问题原因
    ,prob_init_teller_id -- 问题发起柜员编号
    ,issue_dt -- 发布日期
    ,issue_tm -- 发布时间
    ,check_idtfy_rest_cd -- 审核认定结果代码
    ,check_remark -- 审核备注
    ,check_idtfy_rs -- 审核认定原因
    ,authoriz_diret_teller_id -- 授权主管柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.task_no -- 任务号
    ,o.bank_no -- 银行行号
    ,o.sys_id -- 系统编号
    ,o.sub_task_no -- 子任务号
    ,o.init_task_no -- 原任务号
    ,o.task_status_cd -- 任务状态代码
    ,o.payment_flow_num -- 前台流水号
    ,o.ova_flow_num -- 全局流水号
    ,o.tran_code -- 交易码
    ,o.bus_scene_id -- 业务场景编号
    ,o.tran_dt -- 交易日期
    ,o.tran_tm -- 交易时间
    ,o.chn_id -- 渠道编号
    ,o.blip_flow_num -- 影像流水号
    ,o.ghb_acct_id -- 本行账户编号
    ,o.ghb_acct_name -- 本行账户名称
    ,o.invalid_tm -- 失效时间
    ,o.invalid_dt -- 失效日期
    ,o.refuse_rs_descb -- 拒绝原因描述
    ,o.err_idtfy_rs_descb -- 差错认定原因描述
    ,o.opera_mode_cd -- 作业模式代码
    ,o.opera_status_cd -- 作业状态代码
    ,o.remark -- 备注
    ,o.bus_init_teller_id -- 业务发起柜员编号
    ,o.bus_init_director_teller_id -- 业务发起主管柜员编号
    ,o.bus_init_org_id -- 业务发起机构编号
    ,o.oper_status_cd -- 操作状态代码
    ,o.bus_gen_cd -- 业务大类代码
    ,o.prob_node_cd -- 问题节点代码
    ,o.prob_cls_cd -- 问题分类代码
    ,o.prob_init_dt -- 问题发起日期
    ,o.prob_init_tm -- 问题发起时间
    ,o.prob_rs -- 问题原因
    ,o.prob_init_teller_id -- 问题发起柜员编号
    ,o.issue_dt -- 发布日期
    ,o.issue_tm -- 发布时间
    ,o.check_idtfy_rest_cd -- 审核认定结果代码
    ,o.check_remark -- 审核备注
    ,o.check_idtfy_rs -- 审核认定原因
    ,o.authoriz_diret_teller_id -- 授权主管柜员编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_scps_tran_info_h_scpsf1_bk o
    left join ${iml_schema}.agt_scps_tran_info_h_scpsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.task_no = n.task_no
            and o.bank_no = n.bank_no
            and o.sys_id = n.sys_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_scps_tran_info_h_scpsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.task_no = d.task_no
            and o.bank_no = d.bank_no
            and o.sys_id = d.sys_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_scps_tran_info_h;
--alter table ${iml_schema}.agt_scps_tran_info_h truncate partition for ('scpsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_scps_tran_info_h') 
               and substr(subpartition_name,1,8)=upper('p_scpsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_scps_tran_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_scps_tran_info_h modify partition p_scpsf1 
add subpartition p_scpsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_scps_tran_info_h exchange subpartition p_scpsf1_${batch_date} with table ${iml_schema}.agt_scps_tran_info_h_scpsf1_cl;
alter table ${iml_schema}.agt_scps_tran_info_h exchange subpartition p_scpsf1_20991231 with table ${iml_schema}.agt_scps_tran_info_h_scpsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_scps_tran_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_scps_tran_info_h_scpsf1_tm purge;
drop table ${iml_schema}.agt_scps_tran_info_h_scpsf1_op purge;
drop table ${iml_schema}.agt_scps_tran_info_h_scpsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_scps_tran_info_h_scpsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_scps_tran_info_h', partname => 'p_scpsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
