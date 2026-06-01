/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_exp_coll_h_isbsf1
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
alter table ${iml_schema}.agt_exp_coll_h add partition p_isbsf1 values ('isbsf1')(
        subpartition p_isbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_isbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_exp_coll_h_isbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_exp_coll_h partition for ('isbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_exp_coll_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_exp_coll_h_isbsf1_op purge;
drop table ${iml_schema}.agt_exp_coll_h_isbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_exp_coll_h_isbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,bus_id -- 业务编号
    ,tran_descb -- 交易描述
    ,shipment_dt -- 装船日期
    ,sugst_dt -- 提示日期
    ,present_dt -- 交单日期
    ,send_bill_dt -- 寄单日期
    ,advise_dt -- 通知日期
    ,valid_pay_dt -- 有效付款日期
    ,bus_cmplt_dt -- 业务完成日期
    ,coll_type_cd -- 跟单托收类型代码
    ,vp_days -- 效期天数
    ,tenor_type_cd -- 期限类型代码
    ,traff_doc_type_cd -- 运输单据类型代码
    ,traff_doc_id -- 运输单据编号
    ,traff_dt -- 运输日期
    ,traff_tool_type_cd -- 运输工具类型代码
    ,coll_bk_fee_refuse_flg -- 代收行费用遭拒付时放弃标志
    ,ghb_refuse_pay_flg -- 我方费用遭拒付时放弃标志
    ,pay_src_cd -- 付款来源代码
    ,cty_cd -- 国家代码
    ,cargo_type_cd -- 货物类型代码
    ,acquiri_bank_rgst_dt -- 收单行登记日期
    ,bus_teller_id -- 业务柜员编号
    ,free_pay_present_flg -- 免付款交单标志
    ,dir_coll_flg -- 直接托收标志
    ,clean_coll_open_dt -- 光票托收开立日期
    ,blend_pay_flg -- 混合付款标志
    ,delay_pay_type_cd -- 延期付款类型代码
    ,doc_status_cd -- 单据状态代码
    ,secd_recv_bank_cd -- 第二接收行代码
    ,overs_comm_fee -- 国外手续费
    ,belong_org_id -- 所属机构编号
    ,trast_org_id -- 办理机构编号
    ,nra_pay_flg -- NRA付款标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_exp_coll_h partition for ('isbsf1')
where 0=1
;

create table ${iml_schema}.agt_exp_coll_h_isbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_exp_coll_h partition for ('isbsf1') where 0=1;

create table ${iml_schema}.agt_exp_coll_h_isbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_exp_coll_h partition for ('isbsf1') where 0=1;

-- 3.1 get new data into table
-- isbs_bod-1
insert into ${iml_schema}.agt_exp_coll_h_isbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,bus_id -- 业务编号
    ,tran_descb -- 交易描述
    ,shipment_dt -- 装船日期
    ,sugst_dt -- 提示日期
    ,present_dt -- 交单日期
    ,send_bill_dt -- 寄单日期
    ,advise_dt -- 通知日期
    ,valid_pay_dt -- 有效付款日期
    ,bus_cmplt_dt -- 业务完成日期
    ,coll_type_cd -- 跟单托收类型代码
    ,vp_days -- 效期天数
    ,tenor_type_cd -- 期限类型代码
    ,traff_doc_type_cd -- 运输单据类型代码
    ,traff_doc_id -- 运输单据编号
    ,traff_dt -- 运输日期
    ,traff_tool_type_cd -- 运输工具类型代码
    ,coll_bk_fee_refuse_flg -- 代收行费用遭拒付时放弃标志
    ,ghb_refuse_pay_flg -- 我方费用遭拒付时放弃标志
    ,pay_src_cd -- 付款来源代码
    ,cty_cd -- 国家代码
    ,cargo_type_cd -- 货物类型代码
    ,acquiri_bank_rgst_dt -- 收单行登记日期
    ,bus_teller_id -- 业务柜员编号
    ,free_pay_present_flg -- 免付款交单标志
    ,dir_coll_flg -- 直接托收标志
    ,clean_coll_open_dt -- 光票托收开立日期
    ,blend_pay_flg -- 混合付款标志
    ,delay_pay_type_cd -- 延期付款类型代码
    ,doc_status_cd -- 单据状态代码
    ,secd_recv_bank_cd -- 第二接收行代码
    ,overs_comm_fee -- 国外手续费
    ,belong_org_id -- 所属机构编号
    ,trast_org_id -- 办理机构编号
    ,nra_pay_flg -- NRA付款标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222308'||P1.INR -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INR -- 源协议编号
    ,P1.OWNREF -- 业务编号
    ,P1.NAM -- 交易描述
    ,P1.SHPDAT -- 装船日期
    ,P1.PREDAT -- 提示日期
    ,P1.RCVDAT -- 交单日期
    ,P1.OPNDAT -- 寄单日期
    ,P1.ADVDAT -- 通知日期
    ,P1.MATDAT -- 有效付款日期
    ,P1.CLSDAT -- 业务完成日期
    ,nvl(trim(P1.DOCTYPCOD),'-') -- 跟单托收类型代码
    ,P1.MATPERCNT -- 效期天数
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.MATPERTYP END -- 期限类型代码
    ,nvl(trim(P1.TRPDOCTYP),'-') -- 运输单据类型代码
    ,P1.TRPDOCNUM -- 运输单据编号
    ,P1.TRADAT -- 运输日期
    ,nvl(trim(P1.TRAMOD),'-') -- 运输工具类型代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.WAICOLCOD END -- 代收行费用遭拒付时放弃标志
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.WAIRMTCOD END -- 我方费用遭拒付时放弃标志
    ,nvl(trim(P1.CHATO),'-') -- 付款来源代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.STACTY END -- 国家代码
    ,nvl(trim(P1.STAGOD),'-') -- 货物类型代码
    ,P1.CREDAT -- 收单行登记日期
    ,P1.OWNUSR -- 业务柜员编号
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.FOCFLG END -- 免付款交单标志
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.DIRCOLFLG END -- 直接托收标志
    ,P1.ISSDAT -- 光票托收开立日期
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.MATTXTFLG END -- 混合付款标志
    ,nvl(trim(P1.OTHINS),'-') -- 延期付款类型代码
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||P1.DOCSTA END -- 单据状态代码
    ,nvl(trim(P1.MSGROL),'-') -- 第二接收行代码
    ,P1.LESCOM -- 国外手续费
    ,P2.BRANCH -- 所属机构编号
    ,P3.BRANCH -- 办理机构编号
    ,CASE WHEN R9.TARGET_CD_VAL IS NOT NULL THEN R9.TARGET_CD_VAL ELSE '@'||P1.NRAFLG END -- NRA付款标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'isbs_bod' -- 源表名称
    ,'isbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_bod p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.MATPERTYP = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ISBS'
        AND R1.SRC_TAB_EN_NAME= 'ISBS_BOD'
        AND R1.SRC_FIELD_EN_NAME= 'MATPERTYP'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_EXP_COLL_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TENOR_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.WAICOLCOD = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ISBS'
        AND R2.SRC_TAB_EN_NAME= 'ISBS_BOD'
        AND R2.SRC_FIELD_EN_NAME= 'WAICOLCOD'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_EXP_COLL_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'COLL_BK_FEE_REFUSE_FLG'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.WAIRMTCOD = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'ISBS'
        AND R3.SRC_TAB_EN_NAME= 'ISBS_BOD'
        AND R3.SRC_FIELD_EN_NAME= 'WAIRMTCOD'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_EXP_COLL_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'GHB_REFUSE_PAY_FLG'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.STACTY = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'ISBS'
        AND R4.SRC_TAB_EN_NAME= 'ISBS_BOD'
        AND R4.SRC_FIELD_EN_NAME= 'STACTY'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_EXP_COLL_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'CTY_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.FOCFLG = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'ISBS'
        AND R5.SRC_TAB_EN_NAME= 'ISBS_BOD'
        AND R5.SRC_FIELD_EN_NAME= 'FOCFLG'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_EXP_COLL_H'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'FREE_PAY_PRESENT_FLG'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.DIRCOLFLG = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'ISBS'
        AND R6.SRC_TAB_EN_NAME= 'ISBS_BOD'
        AND R6.SRC_FIELD_EN_NAME= 'DIRCOLFLG'
        AND R6.TARGET_TAB_EN_NAME= 'AGT_EXP_COLL_H'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'DIR_COLL_FLG'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.MATTXTFLG = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'ISBS'
        AND R7.SRC_TAB_EN_NAME= 'ISBS_BOD'
        AND R7.SRC_FIELD_EN_NAME= 'MATTXTFLG'
        AND R7.TARGET_TAB_EN_NAME= 'AGT_EXP_COLL_H'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'BLEND_PAY_FLG'
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.DOCSTA = R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'ISBS'
        AND R8.SRC_TAB_EN_NAME= 'ISBS_BOD'
        AND R8.SRC_FIELD_EN_NAME= 'DOCSTA'
        AND R8.TARGET_TAB_EN_NAME= 'AGT_EXP_COLL_H'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'DOC_STATUS_CD'
    left join ${iol_schema}.isbs_bch p2 on P1.BRANCHINR=p2.inr
and p2.start_dt <= to_date('${batch_date}','yyyymmdd') and p2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_bch p3 on P1.BCHKEYINR=p3.inr
and p3.start_dt <= to_date('${batch_date}','yyyymmdd') and p3.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r9 on P1.NRAFLG = R9.SRC_CODE_VAL
        AND R9.SORC_SYS_CD= 'ISBS'
        AND R9.SRC_TAB_EN_NAME= 'ISBS_BOD'
        AND R9.SRC_FIELD_EN_NAME= 'NRAFLG'
        AND R9.TARGET_TAB_EN_NAME= 'AGT_EXP_COLL_H'
        AND R9.TARGET_TAB_FIELD_EN_NAME= 'NRA_PAY_FLG'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_exp_coll_h_isbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,bus_id -- 业务编号
    ,tran_descb -- 交易描述
    ,shipment_dt -- 装船日期
    ,sugst_dt -- 提示日期
    ,present_dt -- 交单日期
    ,send_bill_dt -- 寄单日期
    ,advise_dt -- 通知日期
    ,valid_pay_dt -- 有效付款日期
    ,bus_cmplt_dt -- 业务完成日期
    ,coll_type_cd -- 跟单托收类型代码
    ,vp_days -- 效期天数
    ,tenor_type_cd -- 期限类型代码
    ,traff_doc_type_cd -- 运输单据类型代码
    ,traff_doc_id -- 运输单据编号
    ,traff_dt -- 运输日期
    ,traff_tool_type_cd -- 运输工具类型代码
    ,coll_bk_fee_refuse_flg -- 代收行费用遭拒付时放弃标志
    ,ghb_refuse_pay_flg -- 我方费用遭拒付时放弃标志
    ,pay_src_cd -- 付款来源代码
    ,cty_cd -- 国家代码
    ,cargo_type_cd -- 货物类型代码
    ,acquiri_bank_rgst_dt -- 收单行登记日期
    ,bus_teller_id -- 业务柜员编号
    ,free_pay_present_flg -- 免付款交单标志
    ,dir_coll_flg -- 直接托收标志
    ,clean_coll_open_dt -- 光票托收开立日期
    ,blend_pay_flg -- 混合付款标志
    ,delay_pay_type_cd -- 延期付款类型代码
    ,doc_status_cd -- 单据状态代码
    ,secd_recv_bank_cd -- 第二接收行代码
    ,overs_comm_fee -- 国外手续费
    ,belong_org_id -- 所属机构编号
    ,trast_org_id -- 办理机构编号
    ,nra_pay_flg -- NRA付款标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_exp_coll_h_isbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,bus_id -- 业务编号
    ,tran_descb -- 交易描述
    ,shipment_dt -- 装船日期
    ,sugst_dt -- 提示日期
    ,present_dt -- 交单日期
    ,send_bill_dt -- 寄单日期
    ,advise_dt -- 通知日期
    ,valid_pay_dt -- 有效付款日期
    ,bus_cmplt_dt -- 业务完成日期
    ,coll_type_cd -- 跟单托收类型代码
    ,vp_days -- 效期天数
    ,tenor_type_cd -- 期限类型代码
    ,traff_doc_type_cd -- 运输单据类型代码
    ,traff_doc_id -- 运输单据编号
    ,traff_dt -- 运输日期
    ,traff_tool_type_cd -- 运输工具类型代码
    ,coll_bk_fee_refuse_flg -- 代收行费用遭拒付时放弃标志
    ,ghb_refuse_pay_flg -- 我方费用遭拒付时放弃标志
    ,pay_src_cd -- 付款来源代码
    ,cty_cd -- 国家代码
    ,cargo_type_cd -- 货物类型代码
    ,acquiri_bank_rgst_dt -- 收单行登记日期
    ,bus_teller_id -- 业务柜员编号
    ,free_pay_present_flg -- 免付款交单标志
    ,dir_coll_flg -- 直接托收标志
    ,clean_coll_open_dt -- 光票托收开立日期
    ,blend_pay_flg -- 混合付款标志
    ,delay_pay_type_cd -- 延期付款类型代码
    ,doc_status_cd -- 单据状态代码
    ,secd_recv_bank_cd -- 第二接收行代码
    ,overs_comm_fee -- 国外手续费
    ,belong_org_id -- 所属机构编号
    ,trast_org_id -- 办理机构编号
    ,nra_pay_flg -- NRA付款标志
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
    ,nvl(n.src_agt_id, o.src_agt_id) as src_agt_id -- 源协议编号
    ,nvl(n.bus_id, o.bus_id) as bus_id -- 业务编号
    ,nvl(n.tran_descb, o.tran_descb) as tran_descb -- 交易描述
    ,nvl(n.shipment_dt, o.shipment_dt) as shipment_dt -- 装船日期
    ,nvl(n.sugst_dt, o.sugst_dt) as sugst_dt -- 提示日期
    ,nvl(n.present_dt, o.present_dt) as present_dt -- 交单日期
    ,nvl(n.send_bill_dt, o.send_bill_dt) as send_bill_dt -- 寄单日期
    ,nvl(n.advise_dt, o.advise_dt) as advise_dt -- 通知日期
    ,nvl(n.valid_pay_dt, o.valid_pay_dt) as valid_pay_dt -- 有效付款日期
    ,nvl(n.bus_cmplt_dt, o.bus_cmplt_dt) as bus_cmplt_dt -- 业务完成日期
    ,nvl(n.coll_type_cd, o.coll_type_cd) as coll_type_cd -- 跟单托收类型代码
    ,nvl(n.vp_days, o.vp_days) as vp_days -- 效期天数
    ,nvl(n.tenor_type_cd, o.tenor_type_cd) as tenor_type_cd -- 期限类型代码
    ,nvl(n.traff_doc_type_cd, o.traff_doc_type_cd) as traff_doc_type_cd -- 运输单据类型代码
    ,nvl(n.traff_doc_id, o.traff_doc_id) as traff_doc_id -- 运输单据编号
    ,nvl(n.traff_dt, o.traff_dt) as traff_dt -- 运输日期
    ,nvl(n.traff_tool_type_cd, o.traff_tool_type_cd) as traff_tool_type_cd -- 运输工具类型代码
    ,nvl(n.coll_bk_fee_refuse_flg, o.coll_bk_fee_refuse_flg) as coll_bk_fee_refuse_flg -- 代收行费用遭拒付时放弃标志
    ,nvl(n.ghb_refuse_pay_flg, o.ghb_refuse_pay_flg) as ghb_refuse_pay_flg -- 我方费用遭拒付时放弃标志
    ,nvl(n.pay_src_cd, o.pay_src_cd) as pay_src_cd -- 付款来源代码
    ,nvl(n.cty_cd, o.cty_cd) as cty_cd -- 国家代码
    ,nvl(n.cargo_type_cd, o.cargo_type_cd) as cargo_type_cd -- 货物类型代码
    ,nvl(n.acquiri_bank_rgst_dt, o.acquiri_bank_rgst_dt) as acquiri_bank_rgst_dt -- 收单行登记日期
    ,nvl(n.bus_teller_id, o.bus_teller_id) as bus_teller_id -- 业务柜员编号
    ,nvl(n.free_pay_present_flg, o.free_pay_present_flg) as free_pay_present_flg -- 免付款交单标志
    ,nvl(n.dir_coll_flg, o.dir_coll_flg) as dir_coll_flg -- 直接托收标志
    ,nvl(n.clean_coll_open_dt, o.clean_coll_open_dt) as clean_coll_open_dt -- 光票托收开立日期
    ,nvl(n.blend_pay_flg, o.blend_pay_flg) as blend_pay_flg -- 混合付款标志
    ,nvl(n.delay_pay_type_cd, o.delay_pay_type_cd) as delay_pay_type_cd -- 延期付款类型代码
    ,nvl(n.doc_status_cd, o.doc_status_cd) as doc_status_cd -- 单据状态代码
    ,nvl(n.secd_recv_bank_cd, o.secd_recv_bank_cd) as secd_recv_bank_cd -- 第二接收行代码
    ,nvl(n.overs_comm_fee, o.overs_comm_fee) as overs_comm_fee -- 国外手续费
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.trast_org_id, o.trast_org_id) as trast_org_id -- 办理机构编号
    ,nvl(n.nra_pay_flg, o.nra_pay_flg) as nra_pay_flg -- NRA付款标志
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_exp_coll_h_isbsf1_tm n
    full join (select * from ${iml_schema}.agt_exp_coll_h_isbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.src_agt_id <> n.src_agt_id
        or o.bus_id <> n.bus_id
        or o.tran_descb <> n.tran_descb
        or o.shipment_dt <> n.shipment_dt
        or o.sugst_dt <> n.sugst_dt
        or o.present_dt <> n.present_dt
        or o.send_bill_dt <> n.send_bill_dt
        or o.advise_dt <> n.advise_dt
        or o.valid_pay_dt <> n.valid_pay_dt
        or o.bus_cmplt_dt <> n.bus_cmplt_dt
        or o.coll_type_cd <> n.coll_type_cd
        or o.vp_days <> n.vp_days
        or o.tenor_type_cd <> n.tenor_type_cd
        or o.traff_doc_type_cd <> n.traff_doc_type_cd
        or o.traff_doc_id <> n.traff_doc_id
        or o.traff_dt <> n.traff_dt
        or o.traff_tool_type_cd <> n.traff_tool_type_cd
        or o.coll_bk_fee_refuse_flg <> n.coll_bk_fee_refuse_flg
        or o.ghb_refuse_pay_flg <> n.ghb_refuse_pay_flg
        or o.pay_src_cd <> n.pay_src_cd
        or o.cty_cd <> n.cty_cd
        or o.cargo_type_cd <> n.cargo_type_cd
        or o.acquiri_bank_rgst_dt <> n.acquiri_bank_rgst_dt
        or o.bus_teller_id <> n.bus_teller_id
        or o.free_pay_present_flg <> n.free_pay_present_flg
        or o.dir_coll_flg <> n.dir_coll_flg
        or o.clean_coll_open_dt <> n.clean_coll_open_dt
        or o.blend_pay_flg <> n.blend_pay_flg
        or o.delay_pay_type_cd <> n.delay_pay_type_cd
        or o.doc_status_cd <> n.doc_status_cd
        or o.secd_recv_bank_cd <> n.secd_recv_bank_cd
        or o.overs_comm_fee <> n.overs_comm_fee
        or o.belong_org_id <> n.belong_org_id
        or o.trast_org_id <> n.trast_org_id
        or o.nra_pay_flg <> n.nra_pay_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_exp_coll_h_isbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,bus_id -- 业务编号
    ,tran_descb -- 交易描述
    ,shipment_dt -- 装船日期
    ,sugst_dt -- 提示日期
    ,present_dt -- 交单日期
    ,send_bill_dt -- 寄单日期
    ,advise_dt -- 通知日期
    ,valid_pay_dt -- 有效付款日期
    ,bus_cmplt_dt -- 业务完成日期
    ,coll_type_cd -- 跟单托收类型代码
    ,vp_days -- 效期天数
    ,tenor_type_cd -- 期限类型代码
    ,traff_doc_type_cd -- 运输单据类型代码
    ,traff_doc_id -- 运输单据编号
    ,traff_dt -- 运输日期
    ,traff_tool_type_cd -- 运输工具类型代码
    ,coll_bk_fee_refuse_flg -- 代收行费用遭拒付时放弃标志
    ,ghb_refuse_pay_flg -- 我方费用遭拒付时放弃标志
    ,pay_src_cd -- 付款来源代码
    ,cty_cd -- 国家代码
    ,cargo_type_cd -- 货物类型代码
    ,acquiri_bank_rgst_dt -- 收单行登记日期
    ,bus_teller_id -- 业务柜员编号
    ,free_pay_present_flg -- 免付款交单标志
    ,dir_coll_flg -- 直接托收标志
    ,clean_coll_open_dt -- 光票托收开立日期
    ,blend_pay_flg -- 混合付款标志
    ,delay_pay_type_cd -- 延期付款类型代码
    ,doc_status_cd -- 单据状态代码
    ,secd_recv_bank_cd -- 第二接收行代码
    ,overs_comm_fee -- 国外手续费
    ,belong_org_id -- 所属机构编号
    ,trast_org_id -- 办理机构编号
    ,nra_pay_flg -- NRA付款标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_exp_coll_h_isbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,bus_id -- 业务编号
    ,tran_descb -- 交易描述
    ,shipment_dt -- 装船日期
    ,sugst_dt -- 提示日期
    ,present_dt -- 交单日期
    ,send_bill_dt -- 寄单日期
    ,advise_dt -- 通知日期
    ,valid_pay_dt -- 有效付款日期
    ,bus_cmplt_dt -- 业务完成日期
    ,coll_type_cd -- 跟单托收类型代码
    ,vp_days -- 效期天数
    ,tenor_type_cd -- 期限类型代码
    ,traff_doc_type_cd -- 运输单据类型代码
    ,traff_doc_id -- 运输单据编号
    ,traff_dt -- 运输日期
    ,traff_tool_type_cd -- 运输工具类型代码
    ,coll_bk_fee_refuse_flg -- 代收行费用遭拒付时放弃标志
    ,ghb_refuse_pay_flg -- 我方费用遭拒付时放弃标志
    ,pay_src_cd -- 付款来源代码
    ,cty_cd -- 国家代码
    ,cargo_type_cd -- 货物类型代码
    ,acquiri_bank_rgst_dt -- 收单行登记日期
    ,bus_teller_id -- 业务柜员编号
    ,free_pay_present_flg -- 免付款交单标志
    ,dir_coll_flg -- 直接托收标志
    ,clean_coll_open_dt -- 光票托收开立日期
    ,blend_pay_flg -- 混合付款标志
    ,delay_pay_type_cd -- 延期付款类型代码
    ,doc_status_cd -- 单据状态代码
    ,secd_recv_bank_cd -- 第二接收行代码
    ,overs_comm_fee -- 国外手续费
    ,belong_org_id -- 所属机构编号
    ,trast_org_id -- 办理机构编号
    ,nra_pay_flg -- NRA付款标志
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
    ,o.src_agt_id -- 源协议编号
    ,o.bus_id -- 业务编号
    ,o.tran_descb -- 交易描述
    ,o.shipment_dt -- 装船日期
    ,o.sugst_dt -- 提示日期
    ,o.present_dt -- 交单日期
    ,o.send_bill_dt -- 寄单日期
    ,o.advise_dt -- 通知日期
    ,o.valid_pay_dt -- 有效付款日期
    ,o.bus_cmplt_dt -- 业务完成日期
    ,o.coll_type_cd -- 跟单托收类型代码
    ,o.vp_days -- 效期天数
    ,o.tenor_type_cd -- 期限类型代码
    ,o.traff_doc_type_cd -- 运输单据类型代码
    ,o.traff_doc_id -- 运输单据编号
    ,o.traff_dt -- 运输日期
    ,o.traff_tool_type_cd -- 运输工具类型代码
    ,o.coll_bk_fee_refuse_flg -- 代收行费用遭拒付时放弃标志
    ,o.ghb_refuse_pay_flg -- 我方费用遭拒付时放弃标志
    ,o.pay_src_cd -- 付款来源代码
    ,o.cty_cd -- 国家代码
    ,o.cargo_type_cd -- 货物类型代码
    ,o.acquiri_bank_rgst_dt -- 收单行登记日期
    ,o.bus_teller_id -- 业务柜员编号
    ,o.free_pay_present_flg -- 免付款交单标志
    ,o.dir_coll_flg -- 直接托收标志
    ,o.clean_coll_open_dt -- 光票托收开立日期
    ,o.blend_pay_flg -- 混合付款标志
    ,o.delay_pay_type_cd -- 延期付款类型代码
    ,o.doc_status_cd -- 单据状态代码
    ,o.secd_recv_bank_cd -- 第二接收行代码
    ,o.overs_comm_fee -- 国外手续费
    ,o.belong_org_id -- 所属机构编号
    ,o.trast_org_id -- 办理机构编号
    ,o.nra_pay_flg -- NRA付款标志
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_exp_coll_h_isbsf1_bk o
    left join ${iml_schema}.agt_exp_coll_h_isbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_exp_coll_h_isbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_exp_coll_h;
alter table ${iml_schema}.agt_exp_coll_h truncate partition for ('isbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_exp_coll_h exchange subpartition p_isbsf1_19000101 with table ${iml_schema}.agt_exp_coll_h_isbsf1_cl;
alter table ${iml_schema}.agt_exp_coll_h exchange subpartition p_isbsf1_20991231 with table ${iml_schema}.agt_exp_coll_h_isbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_exp_coll_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_exp_coll_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_exp_coll_h_isbsf1_op purge;
drop table ${iml_schema}.agt_exp_coll_h_isbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_exp_coll_h_isbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_exp_coll_h', partname => 'p_isbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
