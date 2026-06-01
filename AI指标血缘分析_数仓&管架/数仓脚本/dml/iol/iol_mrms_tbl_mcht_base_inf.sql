/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mrms_tbl_mcht_base_inf
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
create table ${iol_schema}.mrms_tbl_mcht_base_inf_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mrms_tbl_mcht_base_inf
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_mcht_base_inf_op purge;
drop table ${iol_schema}.mrms_tbl_mcht_base_inf_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_mcht_base_inf_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_mcht_base_inf where 0=1;

create table ${iol_schema}.mrms_tbl_mcht_base_inf_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_mcht_base_inf where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_mcht_base_inf_cl(
            mcht_no -- 商户号
            ,mcht_nm -- 商户名称
            ,risl_lvl -- 商户风险级别
            ,mcht_lvl -- 商户级别
            ,mcht_status -- 商户状态
            ,manu_auth_flag -- 是否支持人工授权
            ,part_num -- 商户分期期数
            ,disc_cons_flg -- 折扣消费标志
            ,disc_cons_rebate -- 折扣消费率
            ,pass_flag -- 是否支持无磁无密交易
            ,open_days -- 开展业务天数
            ,sleep_days -- 连续无法交易天数
            ,mcht_cn_abbr -- 中文名称简写
            ,spell_name -- 商户拼音缩写
            ,eng_name -- 商户英文名称
            ,mcht_en_abbr -- 商户英文名称缩写
            ,area_no -- 区域代码
            ,settle_area_no -- 清算区域代码
            ,addr -- 商户地址
            ,home_page -- 公司地址
            ,mcc -- 商户MCC码
            ,tcc -- 商户类型码
            ,etps_attr -- 企业性质
            ,mng_mcht_id -- 上级商户号
            ,mcht_grp -- 商户组
            ,mcht_attr -- 专户商户ID
            ,mcht_group_flag -- 商户种类
            ,mcht_group_id -- 集团商户ID
            ,mcht_eng_nm -- 集团商户英文名称
            ,mcht_eng_addr -- 商户英文地址
            ,mcht_eng_city_name -- 商户所在城市
            ,sa_limit_amt -- 受控处理金额(单笔)
            ,sa_action -- 受控处理动作
            ,psam_num -- PSAM卡数量
            ,cd_mac_num -- 押卡机已发数量
            ,pos_num -- POS机已发数量
            ,conn_type -- 连接方式
            ,mcht_mng_mode -- 是否仅营业时间内交易
            ,mcht_function -- 商户功能
            ,licence_no -- 营业执照号码
            ,licence_end_date -- 营业执照有效期
            ,bank_licence_no -- 机构代码证号码
            ,bus_type -- 营业性质
            ,fax_no -- 税务登记证号码
            ,bus_amt -- 注册资金
            ,mcht_cre_lvl -- 企业资质等级
            ,contact -- 联系人姓名
            ,post_code -- 邮编
            ,comm_email -- 联系人电子邮箱
            ,comm_mobil -- 联系人手机
            ,comm_tel -- 联系人电话
            ,manager -- 法人姓名
            ,artif_certif_tp -- 法人证件类型
            ,identity_no -- 法人证件号码
            ,manager_tel -- 法人联系电话
            ,fax -- 传真
            ,electrofax -- 电传
            ,reg_addr -- 注册地址
            ,apply_date -- 申请日期
            ,enable_date -- 启用日期
            ,pre_aud_nm -- 初审人
            ,confirm_nm -- 批准人
            ,protocal_id -- 协议编号
            ,sign_inst_id -- 签约机构代码(银联分配机构号)
            ,net_nm -- 隶属网点代码
            ,agr_br -- 签约网点
            ,net_tel -- 网点电话
            ,prol_date -- 签约日期
            ,prol_tlr -- 签约柜员
            ,close_date -- 撤消签约日期
            ,close_tlr -- 撤消签约柜员
            ,main_tlr -- 维护柜员
            ,check_tlr -- 复核柜员
            ,oper_no -- 客户经理工号
            ,oper_nm -- 客户经理姓名
            ,proc_flag -- 业务处理标志
            ,set_cur -- 外卡入账币种
            ,print_inst_id -- 入账凭单打印机构
            ,acq_inst_id -- 商户所属机构代码
            ,acq_bk_name -- 收单行名称
            ,bank_no -- 分行号
            ,orgn_no -- 卡中心地区号
            ,subbrh_no -- 隶属支行号
            ,subbrh_nm -- 隶属支行名称
            ,open_time -- 商户营业开始时间
            ,close_time -- 商户营业结束时间
            ,vis_act_flg -- VISA外卡受理标志
            ,vis_mcht_id -- VISA商户号
            ,mst_act_flg -- MASTER外卡受理标志
            ,mst_mcht_id -- MASTER商户号
            ,amx_act_flg -- 美运外卡受理标志
            ,amx_mcht_id -- 美运商户号
            ,dnr_act_flg -- 大来外卡受理标志
            ,dnr_mcht_id -- 大来商户号
            ,jcb_act_flg -- JCB外卡受理标志(第三方推广费用)
            ,jcb_mcht_id -- JCB商户号
            ,cup_mcht_flg -- 是否支持他行借记卡
            ,deb_mcht_flg -- 是否支持他行贷记卡
            ,cre_mcht_flg -- 是否支持本行借记卡
            ,cdc_mcht_flg -- 是否支持本行贷记卡
            ,reserved -- 保留
            ,upd_opr_id -- 修改记录操作员
            ,crt_opr_id -- 创建记录操作员
            ,rec_upd_ts -- 记录修改时间
            ,rec_crt_ts -- 记录创建时间
            ,install_tel -- 装机人电话
            ,mcht_grade -- 商户评级 计算评分
            ,reserved1 -- 商户评级信息
            ,reserved2 -- 保留字段
            ,integral_method -- 积分累计方式
            ,integral_rate -- 消费积分比率
            ,integral_fee_limit -- 累计积分限额
            ,integral_number -- 按笔累计积分
            ,acct_flag -- 暂缓入账标识
            ,is_auto_check_level -- 是否自动评级
            ,level1 -- 
            ,level2 -- 
            ,level3 -- 
            ,level4 -- 
            ,level5 -- 
            ,mcht_sync_status -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_mcht_base_inf_op(
            mcht_no -- 商户号
            ,mcht_nm -- 商户名称
            ,risl_lvl -- 商户风险级别
            ,mcht_lvl -- 商户级别
            ,mcht_status -- 商户状态
            ,manu_auth_flag -- 是否支持人工授权
            ,part_num -- 商户分期期数
            ,disc_cons_flg -- 折扣消费标志
            ,disc_cons_rebate -- 折扣消费率
            ,pass_flag -- 是否支持无磁无密交易
            ,open_days -- 开展业务天数
            ,sleep_days -- 连续无法交易天数
            ,mcht_cn_abbr -- 中文名称简写
            ,spell_name -- 商户拼音缩写
            ,eng_name -- 商户英文名称
            ,mcht_en_abbr -- 商户英文名称缩写
            ,area_no -- 区域代码
            ,settle_area_no -- 清算区域代码
            ,addr -- 商户地址
            ,home_page -- 公司地址
            ,mcc -- 商户MCC码
            ,tcc -- 商户类型码
            ,etps_attr -- 企业性质
            ,mng_mcht_id -- 上级商户号
            ,mcht_grp -- 商户组
            ,mcht_attr -- 专户商户ID
            ,mcht_group_flag -- 商户种类
            ,mcht_group_id -- 集团商户ID
            ,mcht_eng_nm -- 集团商户英文名称
            ,mcht_eng_addr -- 商户英文地址
            ,mcht_eng_city_name -- 商户所在城市
            ,sa_limit_amt -- 受控处理金额(单笔)
            ,sa_action -- 受控处理动作
            ,psam_num -- PSAM卡数量
            ,cd_mac_num -- 押卡机已发数量
            ,pos_num -- POS机已发数量
            ,conn_type -- 连接方式
            ,mcht_mng_mode -- 是否仅营业时间内交易
            ,mcht_function -- 商户功能
            ,licence_no -- 营业执照号码
            ,licence_end_date -- 营业执照有效期
            ,bank_licence_no -- 机构代码证号码
            ,bus_type -- 营业性质
            ,fax_no -- 税务登记证号码
            ,bus_amt -- 注册资金
            ,mcht_cre_lvl -- 企业资质等级
            ,contact -- 联系人姓名
            ,post_code -- 邮编
            ,comm_email -- 联系人电子邮箱
            ,comm_mobil -- 联系人手机
            ,comm_tel -- 联系人电话
            ,manager -- 法人姓名
            ,artif_certif_tp -- 法人证件类型
            ,identity_no -- 法人证件号码
            ,manager_tel -- 法人联系电话
            ,fax -- 传真
            ,electrofax -- 电传
            ,reg_addr -- 注册地址
            ,apply_date -- 申请日期
            ,enable_date -- 启用日期
            ,pre_aud_nm -- 初审人
            ,confirm_nm -- 批准人
            ,protocal_id -- 协议编号
            ,sign_inst_id -- 签约机构代码(银联分配机构号)
            ,net_nm -- 隶属网点代码
            ,agr_br -- 签约网点
            ,net_tel -- 网点电话
            ,prol_date -- 签约日期
            ,prol_tlr -- 签约柜员
            ,close_date -- 撤消签约日期
            ,close_tlr -- 撤消签约柜员
            ,main_tlr -- 维护柜员
            ,check_tlr -- 复核柜员
            ,oper_no -- 客户经理工号
            ,oper_nm -- 客户经理姓名
            ,proc_flag -- 业务处理标志
            ,set_cur -- 外卡入账币种
            ,print_inst_id -- 入账凭单打印机构
            ,acq_inst_id -- 商户所属机构代码
            ,acq_bk_name -- 收单行名称
            ,bank_no -- 分行号
            ,orgn_no -- 卡中心地区号
            ,subbrh_no -- 隶属支行号
            ,subbrh_nm -- 隶属支行名称
            ,open_time -- 商户营业开始时间
            ,close_time -- 商户营业结束时间
            ,vis_act_flg -- VISA外卡受理标志
            ,vis_mcht_id -- VISA商户号
            ,mst_act_flg -- MASTER外卡受理标志
            ,mst_mcht_id -- MASTER商户号
            ,amx_act_flg -- 美运外卡受理标志
            ,amx_mcht_id -- 美运商户号
            ,dnr_act_flg -- 大来外卡受理标志
            ,dnr_mcht_id -- 大来商户号
            ,jcb_act_flg -- JCB外卡受理标志(第三方推广费用)
            ,jcb_mcht_id -- JCB商户号
            ,cup_mcht_flg -- 是否支持他行借记卡
            ,deb_mcht_flg -- 是否支持他行贷记卡
            ,cre_mcht_flg -- 是否支持本行借记卡
            ,cdc_mcht_flg -- 是否支持本行贷记卡
            ,reserved -- 保留
            ,upd_opr_id -- 修改记录操作员
            ,crt_opr_id -- 创建记录操作员
            ,rec_upd_ts -- 记录修改时间
            ,rec_crt_ts -- 记录创建时间
            ,install_tel -- 装机人电话
            ,mcht_grade -- 商户评级 计算评分
            ,reserved1 -- 商户评级信息
            ,reserved2 -- 保留字段
            ,integral_method -- 积分累计方式
            ,integral_rate -- 消费积分比率
            ,integral_fee_limit -- 累计积分限额
            ,integral_number -- 按笔累计积分
            ,acct_flag -- 暂缓入账标识
            ,is_auto_check_level -- 是否自动评级
            ,level1 -- 
            ,level2 -- 
            ,level3 -- 
            ,level4 -- 
            ,level5 -- 
            ,mcht_sync_status -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.mcht_no, o.mcht_no) as mcht_no -- 商户号
    ,nvl(n.mcht_nm, o.mcht_nm) as mcht_nm -- 商户名称
    ,nvl(n.risl_lvl, o.risl_lvl) as risl_lvl -- 商户风险级别
    ,nvl(n.mcht_lvl, o.mcht_lvl) as mcht_lvl -- 商户级别
    ,nvl(n.mcht_status, o.mcht_status) as mcht_status -- 商户状态
    ,nvl(n.manu_auth_flag, o.manu_auth_flag) as manu_auth_flag -- 是否支持人工授权
    ,nvl(n.part_num, o.part_num) as part_num -- 商户分期期数
    ,nvl(n.disc_cons_flg, o.disc_cons_flg) as disc_cons_flg -- 折扣消费标志
    ,nvl(n.disc_cons_rebate, o.disc_cons_rebate) as disc_cons_rebate -- 折扣消费率
    ,nvl(n.pass_flag, o.pass_flag) as pass_flag -- 是否支持无磁无密交易
    ,nvl(n.open_days, o.open_days) as open_days -- 开展业务天数
    ,nvl(n.sleep_days, o.sleep_days) as sleep_days -- 连续无法交易天数
    ,nvl(n.mcht_cn_abbr, o.mcht_cn_abbr) as mcht_cn_abbr -- 中文名称简写
    ,nvl(n.spell_name, o.spell_name) as spell_name -- 商户拼音缩写
    ,nvl(n.eng_name, o.eng_name) as eng_name -- 商户英文名称
    ,nvl(n.mcht_en_abbr, o.mcht_en_abbr) as mcht_en_abbr -- 商户英文名称缩写
    ,nvl(n.area_no, o.area_no) as area_no -- 区域代码
    ,nvl(n.settle_area_no, o.settle_area_no) as settle_area_no -- 清算区域代码
    ,nvl(n.addr, o.addr) as addr -- 商户地址
    ,nvl(n.home_page, o.home_page) as home_page -- 公司地址
    ,nvl(n.mcc, o.mcc) as mcc -- 商户MCC码
    ,nvl(n.tcc, o.tcc) as tcc -- 商户类型码
    ,nvl(n.etps_attr, o.etps_attr) as etps_attr -- 企业性质
    ,nvl(n.mng_mcht_id, o.mng_mcht_id) as mng_mcht_id -- 上级商户号
    ,nvl(n.mcht_grp, o.mcht_grp) as mcht_grp -- 商户组
    ,nvl(n.mcht_attr, o.mcht_attr) as mcht_attr -- 专户商户ID
    ,nvl(n.mcht_group_flag, o.mcht_group_flag) as mcht_group_flag -- 商户种类
    ,nvl(n.mcht_group_id, o.mcht_group_id) as mcht_group_id -- 集团商户ID
    ,nvl(n.mcht_eng_nm, o.mcht_eng_nm) as mcht_eng_nm -- 集团商户英文名称
    ,nvl(n.mcht_eng_addr, o.mcht_eng_addr) as mcht_eng_addr -- 商户英文地址
    ,nvl(n.mcht_eng_city_name, o.mcht_eng_city_name) as mcht_eng_city_name -- 商户所在城市
    ,nvl(n.sa_limit_amt, o.sa_limit_amt) as sa_limit_amt -- 受控处理金额(单笔)
    ,nvl(n.sa_action, o.sa_action) as sa_action -- 受控处理动作
    ,nvl(n.psam_num, o.psam_num) as psam_num -- PSAM卡数量
    ,nvl(n.cd_mac_num, o.cd_mac_num) as cd_mac_num -- 押卡机已发数量
    ,nvl(n.pos_num, o.pos_num) as pos_num -- POS机已发数量
    ,nvl(n.conn_type, o.conn_type) as conn_type -- 连接方式
    ,nvl(n.mcht_mng_mode, o.mcht_mng_mode) as mcht_mng_mode -- 是否仅营业时间内交易
    ,nvl(n.mcht_function, o.mcht_function) as mcht_function -- 商户功能
    ,nvl(n.licence_no, o.licence_no) as licence_no -- 营业执照号码
    ,nvl(n.licence_end_date, o.licence_end_date) as licence_end_date -- 营业执照有效期
    ,nvl(n.bank_licence_no, o.bank_licence_no) as bank_licence_no -- 机构代码证号码
    ,nvl(n.bus_type, o.bus_type) as bus_type -- 营业性质
    ,nvl(n.fax_no, o.fax_no) as fax_no -- 税务登记证号码
    ,nvl(n.bus_amt, o.bus_amt) as bus_amt -- 注册资金
    ,nvl(n.mcht_cre_lvl, o.mcht_cre_lvl) as mcht_cre_lvl -- 企业资质等级
    ,nvl(n.contact, o.contact) as contact -- 联系人姓名
    ,nvl(n.post_code, o.post_code) as post_code -- 邮编
    ,nvl(n.comm_email, o.comm_email) as comm_email -- 联系人电子邮箱
    ,nvl(n.comm_mobil, o.comm_mobil) as comm_mobil -- 联系人手机
    ,nvl(n.comm_tel, o.comm_tel) as comm_tel -- 联系人电话
    ,nvl(n.manager, o.manager) as manager -- 法人姓名
    ,nvl(n.artif_certif_tp, o.artif_certif_tp) as artif_certif_tp -- 法人证件类型
    ,nvl(n.identity_no, o.identity_no) as identity_no -- 法人证件号码
    ,nvl(n.manager_tel, o.manager_tel) as manager_tel -- 法人联系电话
    ,nvl(n.fax, o.fax) as fax -- 传真
    ,nvl(n.electrofax, o.electrofax) as electrofax -- 电传
    ,nvl(n.reg_addr, o.reg_addr) as reg_addr -- 注册地址
    ,nvl(n.apply_date, o.apply_date) as apply_date -- 申请日期
    ,nvl(n.enable_date, o.enable_date) as enable_date -- 启用日期
    ,nvl(n.pre_aud_nm, o.pre_aud_nm) as pre_aud_nm -- 初审人
    ,nvl(n.confirm_nm, o.confirm_nm) as confirm_nm -- 批准人
    ,nvl(n.protocal_id, o.protocal_id) as protocal_id -- 协议编号
    ,nvl(n.sign_inst_id, o.sign_inst_id) as sign_inst_id -- 签约机构代码(银联分配机构号)
    ,nvl(n.net_nm, o.net_nm) as net_nm -- 隶属网点代码
    ,nvl(n.agr_br, o.agr_br) as agr_br -- 签约网点
    ,nvl(n.net_tel, o.net_tel) as net_tel -- 网点电话
    ,nvl(n.prol_date, o.prol_date) as prol_date -- 签约日期
    ,nvl(n.prol_tlr, o.prol_tlr) as prol_tlr -- 签约柜员
    ,nvl(n.close_date, o.close_date) as close_date -- 撤消签约日期
    ,nvl(n.close_tlr, o.close_tlr) as close_tlr -- 撤消签约柜员
    ,nvl(n.main_tlr, o.main_tlr) as main_tlr -- 维护柜员
    ,nvl(n.check_tlr, o.check_tlr) as check_tlr -- 复核柜员
    ,nvl(n.oper_no, o.oper_no) as oper_no -- 客户经理工号
    ,nvl(n.oper_nm, o.oper_nm) as oper_nm -- 客户经理姓名
    ,nvl(n.proc_flag, o.proc_flag) as proc_flag -- 业务处理标志
    ,nvl(n.set_cur, o.set_cur) as set_cur -- 外卡入账币种
    ,nvl(n.print_inst_id, o.print_inst_id) as print_inst_id -- 入账凭单打印机构
    ,nvl(n.acq_inst_id, o.acq_inst_id) as acq_inst_id -- 商户所属机构代码
    ,nvl(n.acq_bk_name, o.acq_bk_name) as acq_bk_name -- 收单行名称
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 分行号
    ,nvl(n.orgn_no, o.orgn_no) as orgn_no -- 卡中心地区号
    ,nvl(n.subbrh_no, o.subbrh_no) as subbrh_no -- 隶属支行号
    ,nvl(n.subbrh_nm, o.subbrh_nm) as subbrh_nm -- 隶属支行名称
    ,nvl(n.open_time, o.open_time) as open_time -- 商户营业开始时间
    ,nvl(n.close_time, o.close_time) as close_time -- 商户营业结束时间
    ,nvl(n.vis_act_flg, o.vis_act_flg) as vis_act_flg -- VISA外卡受理标志
    ,nvl(n.vis_mcht_id, o.vis_mcht_id) as vis_mcht_id -- VISA商户号
    ,nvl(n.mst_act_flg, o.mst_act_flg) as mst_act_flg -- MASTER外卡受理标志
    ,nvl(n.mst_mcht_id, o.mst_mcht_id) as mst_mcht_id -- MASTER商户号
    ,nvl(n.amx_act_flg, o.amx_act_flg) as amx_act_flg -- 美运外卡受理标志
    ,nvl(n.amx_mcht_id, o.amx_mcht_id) as amx_mcht_id -- 美运商户号
    ,nvl(n.dnr_act_flg, o.dnr_act_flg) as dnr_act_flg -- 大来外卡受理标志
    ,nvl(n.dnr_mcht_id, o.dnr_mcht_id) as dnr_mcht_id -- 大来商户号
    ,nvl(n.jcb_act_flg, o.jcb_act_flg) as jcb_act_flg -- JCB外卡受理标志(第三方推广费用)
    ,nvl(n.jcb_mcht_id, o.jcb_mcht_id) as jcb_mcht_id -- JCB商户号
    ,nvl(n.cup_mcht_flg, o.cup_mcht_flg) as cup_mcht_flg -- 是否支持他行借记卡
    ,nvl(n.deb_mcht_flg, o.deb_mcht_flg) as deb_mcht_flg -- 是否支持他行贷记卡
    ,nvl(n.cre_mcht_flg, o.cre_mcht_flg) as cre_mcht_flg -- 是否支持本行借记卡
    ,nvl(n.cdc_mcht_flg, o.cdc_mcht_flg) as cdc_mcht_flg -- 是否支持本行贷记卡
    ,nvl(n.reserved, o.reserved) as reserved -- 保留
    ,nvl(n.upd_opr_id, o.upd_opr_id) as upd_opr_id -- 修改记录操作员
    ,nvl(n.crt_opr_id, o.crt_opr_id) as crt_opr_id -- 创建记录操作员
    ,nvl(n.rec_upd_ts, o.rec_upd_ts) as rec_upd_ts -- 记录修改时间
    ,nvl(n.rec_crt_ts, o.rec_crt_ts) as rec_crt_ts -- 记录创建时间
    ,nvl(n.install_tel, o.install_tel) as install_tel -- 装机人电话
    ,nvl(n.mcht_grade, o.mcht_grade) as mcht_grade -- 商户评级 计算评分
    ,nvl(n.reserved1, o.reserved1) as reserved1 -- 商户评级信息
    ,nvl(n.reserved2, o.reserved2) as reserved2 -- 保留字段
    ,nvl(n.integral_method, o.integral_method) as integral_method -- 积分累计方式
    ,nvl(n.integral_rate, o.integral_rate) as integral_rate -- 消费积分比率
    ,nvl(n.integral_fee_limit, o.integral_fee_limit) as integral_fee_limit -- 累计积分限额
    ,nvl(n.integral_number, o.integral_number) as integral_number -- 按笔累计积分
    ,nvl(n.acct_flag, o.acct_flag) as acct_flag -- 暂缓入账标识
    ,nvl(n.is_auto_check_level, o.is_auto_check_level) as is_auto_check_level -- 是否自动评级
    ,nvl(n.level1, o.level1) as level1 -- 
    ,nvl(n.level2, o.level2) as level2 -- 
    ,nvl(n.level3, o.level3) as level3 -- 
    ,nvl(n.level4, o.level4) as level4 -- 
    ,nvl(n.level5, o.level5) as level5 -- 
    ,nvl(n.mcht_sync_status, o.mcht_sync_status) as mcht_sync_status -- 
    ,case when
            n.mcht_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.mcht_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.mcht_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mrms_tbl_mcht_base_inf_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mrms_tbl_mcht_base_inf where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.mcht_no = n.mcht_no
where (
        o.mcht_no is null
    )
    or (
        n.mcht_no is null
    )
    or (
        o.mcht_nm <> n.mcht_nm
        or o.risl_lvl <> n.risl_lvl
        or o.mcht_lvl <> n.mcht_lvl
        or o.mcht_status <> n.mcht_status
        or o.manu_auth_flag <> n.manu_auth_flag
        or o.part_num <> n.part_num
        or o.disc_cons_flg <> n.disc_cons_flg
        or o.disc_cons_rebate <> n.disc_cons_rebate
        or o.pass_flag <> n.pass_flag
        or o.open_days <> n.open_days
        or o.sleep_days <> n.sleep_days
        or o.mcht_cn_abbr <> n.mcht_cn_abbr
        or o.spell_name <> n.spell_name
        or o.eng_name <> n.eng_name
        or o.mcht_en_abbr <> n.mcht_en_abbr
        or o.area_no <> n.area_no
        or o.settle_area_no <> n.settle_area_no
        or o.addr <> n.addr
        or o.home_page <> n.home_page
        or o.mcc <> n.mcc
        or o.tcc <> n.tcc
        or o.etps_attr <> n.etps_attr
        or o.mng_mcht_id <> n.mng_mcht_id
        or o.mcht_grp <> n.mcht_grp
        or o.mcht_attr <> n.mcht_attr
        or o.mcht_group_flag <> n.mcht_group_flag
        or o.mcht_group_id <> n.mcht_group_id
        or o.mcht_eng_nm <> n.mcht_eng_nm
        or o.mcht_eng_addr <> n.mcht_eng_addr
        or o.mcht_eng_city_name <> n.mcht_eng_city_name
        or o.sa_limit_amt <> n.sa_limit_amt
        or o.sa_action <> n.sa_action
        or o.psam_num <> n.psam_num
        or o.cd_mac_num <> n.cd_mac_num
        or o.pos_num <> n.pos_num
        or o.conn_type <> n.conn_type
        or o.mcht_mng_mode <> n.mcht_mng_mode
        or o.mcht_function <> n.mcht_function
        or o.licence_no <> n.licence_no
        or o.licence_end_date <> n.licence_end_date
        or o.bank_licence_no <> n.bank_licence_no
        or o.bus_type <> n.bus_type
        or o.fax_no <> n.fax_no
        or o.bus_amt <> n.bus_amt
        or o.mcht_cre_lvl <> n.mcht_cre_lvl
        or o.contact <> n.contact
        or o.post_code <> n.post_code
        or o.comm_email <> n.comm_email
        or o.comm_mobil <> n.comm_mobil
        or o.comm_tel <> n.comm_tel
        or o.manager <> n.manager
        or o.artif_certif_tp <> n.artif_certif_tp
        or o.identity_no <> n.identity_no
        or o.manager_tel <> n.manager_tel
        or o.fax <> n.fax
        or o.electrofax <> n.electrofax
        or o.reg_addr <> n.reg_addr
        or o.apply_date <> n.apply_date
        or o.enable_date <> n.enable_date
        or o.pre_aud_nm <> n.pre_aud_nm
        or o.confirm_nm <> n.confirm_nm
        or o.protocal_id <> n.protocal_id
        or o.sign_inst_id <> n.sign_inst_id
        or o.net_nm <> n.net_nm
        or o.agr_br <> n.agr_br
        or o.net_tel <> n.net_tel
        or o.prol_date <> n.prol_date
        or o.prol_tlr <> n.prol_tlr
        or o.close_date <> n.close_date
        or o.close_tlr <> n.close_tlr
        or o.main_tlr <> n.main_tlr
        or o.check_tlr <> n.check_tlr
        or o.oper_no <> n.oper_no
        or o.oper_nm <> n.oper_nm
        or o.proc_flag <> n.proc_flag
        or o.set_cur <> n.set_cur
        or o.print_inst_id <> n.print_inst_id
        or o.acq_inst_id <> n.acq_inst_id
        or o.acq_bk_name <> n.acq_bk_name
        or o.bank_no <> n.bank_no
        or o.orgn_no <> n.orgn_no
        or o.subbrh_no <> n.subbrh_no
        or o.subbrh_nm <> n.subbrh_nm
        or o.open_time <> n.open_time
        or o.close_time <> n.close_time
        or o.vis_act_flg <> n.vis_act_flg
        or o.vis_mcht_id <> n.vis_mcht_id
        or o.mst_act_flg <> n.mst_act_flg
        or o.mst_mcht_id <> n.mst_mcht_id
        or o.amx_act_flg <> n.amx_act_flg
        or o.amx_mcht_id <> n.amx_mcht_id
        or o.dnr_act_flg <> n.dnr_act_flg
        or o.dnr_mcht_id <> n.dnr_mcht_id
        or o.jcb_act_flg <> n.jcb_act_flg
        or o.jcb_mcht_id <> n.jcb_mcht_id
        or o.cup_mcht_flg <> n.cup_mcht_flg
        or o.deb_mcht_flg <> n.deb_mcht_flg
        or o.cre_mcht_flg <> n.cre_mcht_flg
        or o.cdc_mcht_flg <> n.cdc_mcht_flg
        or o.reserved <> n.reserved
        or o.upd_opr_id <> n.upd_opr_id
        or o.crt_opr_id <> n.crt_opr_id
        or o.rec_upd_ts <> n.rec_upd_ts
        or o.rec_crt_ts <> n.rec_crt_ts
        or o.install_tel <> n.install_tel
        or o.mcht_grade <> n.mcht_grade
        or o.reserved1 <> n.reserved1
        or o.reserved2 <> n.reserved2
        or o.integral_method <> n.integral_method
        or o.integral_rate <> n.integral_rate
        or o.integral_fee_limit <> n.integral_fee_limit
        or o.integral_number <> n.integral_number
        or o.acct_flag <> n.acct_flag
        or o.is_auto_check_level <> n.is_auto_check_level
        or o.level1 <> n.level1
        or o.level2 <> n.level2
        or o.level3 <> n.level3
        or o.level4 <> n.level4
        or o.level5 <> n.level5
        or o.mcht_sync_status <> n.mcht_sync_status
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_mcht_base_inf_cl(
            mcht_no -- 商户号
            ,mcht_nm -- 商户名称
            ,risl_lvl -- 商户风险级别
            ,mcht_lvl -- 商户级别
            ,mcht_status -- 商户状态
            ,manu_auth_flag -- 是否支持人工授权
            ,part_num -- 商户分期期数
            ,disc_cons_flg -- 折扣消费标志
            ,disc_cons_rebate -- 折扣消费率
            ,pass_flag -- 是否支持无磁无密交易
            ,open_days -- 开展业务天数
            ,sleep_days -- 连续无法交易天数
            ,mcht_cn_abbr -- 中文名称简写
            ,spell_name -- 商户拼音缩写
            ,eng_name -- 商户英文名称
            ,mcht_en_abbr -- 商户英文名称缩写
            ,area_no -- 区域代码
            ,settle_area_no -- 清算区域代码
            ,addr -- 商户地址
            ,home_page -- 公司地址
            ,mcc -- 商户MCC码
            ,tcc -- 商户类型码
            ,etps_attr -- 企业性质
            ,mng_mcht_id -- 上级商户号
            ,mcht_grp -- 商户组
            ,mcht_attr -- 专户商户ID
            ,mcht_group_flag -- 商户种类
            ,mcht_group_id -- 集团商户ID
            ,mcht_eng_nm -- 集团商户英文名称
            ,mcht_eng_addr -- 商户英文地址
            ,mcht_eng_city_name -- 商户所在城市
            ,sa_limit_amt -- 受控处理金额(单笔)
            ,sa_action -- 受控处理动作
            ,psam_num -- PSAM卡数量
            ,cd_mac_num -- 押卡机已发数量
            ,pos_num -- POS机已发数量
            ,conn_type -- 连接方式
            ,mcht_mng_mode -- 是否仅营业时间内交易
            ,mcht_function -- 商户功能
            ,licence_no -- 营业执照号码
            ,licence_end_date -- 营业执照有效期
            ,bank_licence_no -- 机构代码证号码
            ,bus_type -- 营业性质
            ,fax_no -- 税务登记证号码
            ,bus_amt -- 注册资金
            ,mcht_cre_lvl -- 企业资质等级
            ,contact -- 联系人姓名
            ,post_code -- 邮编
            ,comm_email -- 联系人电子邮箱
            ,comm_mobil -- 联系人手机
            ,comm_tel -- 联系人电话
            ,manager -- 法人姓名
            ,artif_certif_tp -- 法人证件类型
            ,identity_no -- 法人证件号码
            ,manager_tel -- 法人联系电话
            ,fax -- 传真
            ,electrofax -- 电传
            ,reg_addr -- 注册地址
            ,apply_date -- 申请日期
            ,enable_date -- 启用日期
            ,pre_aud_nm -- 初审人
            ,confirm_nm -- 批准人
            ,protocal_id -- 协议编号
            ,sign_inst_id -- 签约机构代码(银联分配机构号)
            ,net_nm -- 隶属网点代码
            ,agr_br -- 签约网点
            ,net_tel -- 网点电话
            ,prol_date -- 签约日期
            ,prol_tlr -- 签约柜员
            ,close_date -- 撤消签约日期
            ,close_tlr -- 撤消签约柜员
            ,main_tlr -- 维护柜员
            ,check_tlr -- 复核柜员
            ,oper_no -- 客户经理工号
            ,oper_nm -- 客户经理姓名
            ,proc_flag -- 业务处理标志
            ,set_cur -- 外卡入账币种
            ,print_inst_id -- 入账凭单打印机构
            ,acq_inst_id -- 商户所属机构代码
            ,acq_bk_name -- 收单行名称
            ,bank_no -- 分行号
            ,orgn_no -- 卡中心地区号
            ,subbrh_no -- 隶属支行号
            ,subbrh_nm -- 隶属支行名称
            ,open_time -- 商户营业开始时间
            ,close_time -- 商户营业结束时间
            ,vis_act_flg -- VISA外卡受理标志
            ,vis_mcht_id -- VISA商户号
            ,mst_act_flg -- MASTER外卡受理标志
            ,mst_mcht_id -- MASTER商户号
            ,amx_act_flg -- 美运外卡受理标志
            ,amx_mcht_id -- 美运商户号
            ,dnr_act_flg -- 大来外卡受理标志
            ,dnr_mcht_id -- 大来商户号
            ,jcb_act_flg -- JCB外卡受理标志(第三方推广费用)
            ,jcb_mcht_id -- JCB商户号
            ,cup_mcht_flg -- 是否支持他行借记卡
            ,deb_mcht_flg -- 是否支持他行贷记卡
            ,cre_mcht_flg -- 是否支持本行借记卡
            ,cdc_mcht_flg -- 是否支持本行贷记卡
            ,reserved -- 保留
            ,upd_opr_id -- 修改记录操作员
            ,crt_opr_id -- 创建记录操作员
            ,rec_upd_ts -- 记录修改时间
            ,rec_crt_ts -- 记录创建时间
            ,install_tel -- 装机人电话
            ,mcht_grade -- 商户评级 计算评分
            ,reserved1 -- 商户评级信息
            ,reserved2 -- 保留字段
            ,integral_method -- 积分累计方式
            ,integral_rate -- 消费积分比率
            ,integral_fee_limit -- 累计积分限额
            ,integral_number -- 按笔累计积分
            ,acct_flag -- 暂缓入账标识
            ,is_auto_check_level -- 是否自动评级
            ,level1 -- 
            ,level2 -- 
            ,level3 -- 
            ,level4 -- 
            ,level5 -- 
            ,mcht_sync_status -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_mcht_base_inf_op(
            mcht_no -- 商户号
            ,mcht_nm -- 商户名称
            ,risl_lvl -- 商户风险级别
            ,mcht_lvl -- 商户级别
            ,mcht_status -- 商户状态
            ,manu_auth_flag -- 是否支持人工授权
            ,part_num -- 商户分期期数
            ,disc_cons_flg -- 折扣消费标志
            ,disc_cons_rebate -- 折扣消费率
            ,pass_flag -- 是否支持无磁无密交易
            ,open_days -- 开展业务天数
            ,sleep_days -- 连续无法交易天数
            ,mcht_cn_abbr -- 中文名称简写
            ,spell_name -- 商户拼音缩写
            ,eng_name -- 商户英文名称
            ,mcht_en_abbr -- 商户英文名称缩写
            ,area_no -- 区域代码
            ,settle_area_no -- 清算区域代码
            ,addr -- 商户地址
            ,home_page -- 公司地址
            ,mcc -- 商户MCC码
            ,tcc -- 商户类型码
            ,etps_attr -- 企业性质
            ,mng_mcht_id -- 上级商户号
            ,mcht_grp -- 商户组
            ,mcht_attr -- 专户商户ID
            ,mcht_group_flag -- 商户种类
            ,mcht_group_id -- 集团商户ID
            ,mcht_eng_nm -- 集团商户英文名称
            ,mcht_eng_addr -- 商户英文地址
            ,mcht_eng_city_name -- 商户所在城市
            ,sa_limit_amt -- 受控处理金额(单笔)
            ,sa_action -- 受控处理动作
            ,psam_num -- PSAM卡数量
            ,cd_mac_num -- 押卡机已发数量
            ,pos_num -- POS机已发数量
            ,conn_type -- 连接方式
            ,mcht_mng_mode -- 是否仅营业时间内交易
            ,mcht_function -- 商户功能
            ,licence_no -- 营业执照号码
            ,licence_end_date -- 营业执照有效期
            ,bank_licence_no -- 机构代码证号码
            ,bus_type -- 营业性质
            ,fax_no -- 税务登记证号码
            ,bus_amt -- 注册资金
            ,mcht_cre_lvl -- 企业资质等级
            ,contact -- 联系人姓名
            ,post_code -- 邮编
            ,comm_email -- 联系人电子邮箱
            ,comm_mobil -- 联系人手机
            ,comm_tel -- 联系人电话
            ,manager -- 法人姓名
            ,artif_certif_tp -- 法人证件类型
            ,identity_no -- 法人证件号码
            ,manager_tel -- 法人联系电话
            ,fax -- 传真
            ,electrofax -- 电传
            ,reg_addr -- 注册地址
            ,apply_date -- 申请日期
            ,enable_date -- 启用日期
            ,pre_aud_nm -- 初审人
            ,confirm_nm -- 批准人
            ,protocal_id -- 协议编号
            ,sign_inst_id -- 签约机构代码(银联分配机构号)
            ,net_nm -- 隶属网点代码
            ,agr_br -- 签约网点
            ,net_tel -- 网点电话
            ,prol_date -- 签约日期
            ,prol_tlr -- 签约柜员
            ,close_date -- 撤消签约日期
            ,close_tlr -- 撤消签约柜员
            ,main_tlr -- 维护柜员
            ,check_tlr -- 复核柜员
            ,oper_no -- 客户经理工号
            ,oper_nm -- 客户经理姓名
            ,proc_flag -- 业务处理标志
            ,set_cur -- 外卡入账币种
            ,print_inst_id -- 入账凭单打印机构
            ,acq_inst_id -- 商户所属机构代码
            ,acq_bk_name -- 收单行名称
            ,bank_no -- 分行号
            ,orgn_no -- 卡中心地区号
            ,subbrh_no -- 隶属支行号
            ,subbrh_nm -- 隶属支行名称
            ,open_time -- 商户营业开始时间
            ,close_time -- 商户营业结束时间
            ,vis_act_flg -- VISA外卡受理标志
            ,vis_mcht_id -- VISA商户号
            ,mst_act_flg -- MASTER外卡受理标志
            ,mst_mcht_id -- MASTER商户号
            ,amx_act_flg -- 美运外卡受理标志
            ,amx_mcht_id -- 美运商户号
            ,dnr_act_flg -- 大来外卡受理标志
            ,dnr_mcht_id -- 大来商户号
            ,jcb_act_flg -- JCB外卡受理标志(第三方推广费用)
            ,jcb_mcht_id -- JCB商户号
            ,cup_mcht_flg -- 是否支持他行借记卡
            ,deb_mcht_flg -- 是否支持他行贷记卡
            ,cre_mcht_flg -- 是否支持本行借记卡
            ,cdc_mcht_flg -- 是否支持本行贷记卡
            ,reserved -- 保留
            ,upd_opr_id -- 修改记录操作员
            ,crt_opr_id -- 创建记录操作员
            ,rec_upd_ts -- 记录修改时间
            ,rec_crt_ts -- 记录创建时间
            ,install_tel -- 装机人电话
            ,mcht_grade -- 商户评级 计算评分
            ,reserved1 -- 商户评级信息
            ,reserved2 -- 保留字段
            ,integral_method -- 积分累计方式
            ,integral_rate -- 消费积分比率
            ,integral_fee_limit -- 累计积分限额
            ,integral_number -- 按笔累计积分
            ,acct_flag -- 暂缓入账标识
            ,is_auto_check_level -- 是否自动评级
            ,level1 -- 
            ,level2 -- 
            ,level3 -- 
            ,level4 -- 
            ,level5 -- 
            ,mcht_sync_status -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.mcht_no -- 商户号
    ,o.mcht_nm -- 商户名称
    ,o.risl_lvl -- 商户风险级别
    ,o.mcht_lvl -- 商户级别
    ,o.mcht_status -- 商户状态
    ,o.manu_auth_flag -- 是否支持人工授权
    ,o.part_num -- 商户分期期数
    ,o.disc_cons_flg -- 折扣消费标志
    ,o.disc_cons_rebate -- 折扣消费率
    ,o.pass_flag -- 是否支持无磁无密交易
    ,o.open_days -- 开展业务天数
    ,o.sleep_days -- 连续无法交易天数
    ,o.mcht_cn_abbr -- 中文名称简写
    ,o.spell_name -- 商户拼音缩写
    ,o.eng_name -- 商户英文名称
    ,o.mcht_en_abbr -- 商户英文名称缩写
    ,o.area_no -- 区域代码
    ,o.settle_area_no -- 清算区域代码
    ,o.addr -- 商户地址
    ,o.home_page -- 公司地址
    ,o.mcc -- 商户MCC码
    ,o.tcc -- 商户类型码
    ,o.etps_attr -- 企业性质
    ,o.mng_mcht_id -- 上级商户号
    ,o.mcht_grp -- 商户组
    ,o.mcht_attr -- 专户商户ID
    ,o.mcht_group_flag -- 商户种类
    ,o.mcht_group_id -- 集团商户ID
    ,o.mcht_eng_nm -- 集团商户英文名称
    ,o.mcht_eng_addr -- 商户英文地址
    ,o.mcht_eng_city_name -- 商户所在城市
    ,o.sa_limit_amt -- 受控处理金额(单笔)
    ,o.sa_action -- 受控处理动作
    ,o.psam_num -- PSAM卡数量
    ,o.cd_mac_num -- 押卡机已发数量
    ,o.pos_num -- POS机已发数量
    ,o.conn_type -- 连接方式
    ,o.mcht_mng_mode -- 是否仅营业时间内交易
    ,o.mcht_function -- 商户功能
    ,o.licence_no -- 营业执照号码
    ,o.licence_end_date -- 营业执照有效期
    ,o.bank_licence_no -- 机构代码证号码
    ,o.bus_type -- 营业性质
    ,o.fax_no -- 税务登记证号码
    ,o.bus_amt -- 注册资金
    ,o.mcht_cre_lvl -- 企业资质等级
    ,o.contact -- 联系人姓名
    ,o.post_code -- 邮编
    ,o.comm_email -- 联系人电子邮箱
    ,o.comm_mobil -- 联系人手机
    ,o.comm_tel -- 联系人电话
    ,o.manager -- 法人姓名
    ,o.artif_certif_tp -- 法人证件类型
    ,o.identity_no -- 法人证件号码
    ,o.manager_tel -- 法人联系电话
    ,o.fax -- 传真
    ,o.electrofax -- 电传
    ,o.reg_addr -- 注册地址
    ,o.apply_date -- 申请日期
    ,o.enable_date -- 启用日期
    ,o.pre_aud_nm -- 初审人
    ,o.confirm_nm -- 批准人
    ,o.protocal_id -- 协议编号
    ,o.sign_inst_id -- 签约机构代码(银联分配机构号)
    ,o.net_nm -- 隶属网点代码
    ,o.agr_br -- 签约网点
    ,o.net_tel -- 网点电话
    ,o.prol_date -- 签约日期
    ,o.prol_tlr -- 签约柜员
    ,o.close_date -- 撤消签约日期
    ,o.close_tlr -- 撤消签约柜员
    ,o.main_tlr -- 维护柜员
    ,o.check_tlr -- 复核柜员
    ,o.oper_no -- 客户经理工号
    ,o.oper_nm -- 客户经理姓名
    ,o.proc_flag -- 业务处理标志
    ,o.set_cur -- 外卡入账币种
    ,o.print_inst_id -- 入账凭单打印机构
    ,o.acq_inst_id -- 商户所属机构代码
    ,o.acq_bk_name -- 收单行名称
    ,o.bank_no -- 分行号
    ,o.orgn_no -- 卡中心地区号
    ,o.subbrh_no -- 隶属支行号
    ,o.subbrh_nm -- 隶属支行名称
    ,o.open_time -- 商户营业开始时间
    ,o.close_time -- 商户营业结束时间
    ,o.vis_act_flg -- VISA外卡受理标志
    ,o.vis_mcht_id -- VISA商户号
    ,o.mst_act_flg -- MASTER外卡受理标志
    ,o.mst_mcht_id -- MASTER商户号
    ,o.amx_act_flg -- 美运外卡受理标志
    ,o.amx_mcht_id -- 美运商户号
    ,o.dnr_act_flg -- 大来外卡受理标志
    ,o.dnr_mcht_id -- 大来商户号
    ,o.jcb_act_flg -- JCB外卡受理标志(第三方推广费用)
    ,o.jcb_mcht_id -- JCB商户号
    ,o.cup_mcht_flg -- 是否支持他行借记卡
    ,o.deb_mcht_flg -- 是否支持他行贷记卡
    ,o.cre_mcht_flg -- 是否支持本行借记卡
    ,o.cdc_mcht_flg -- 是否支持本行贷记卡
    ,o.reserved -- 保留
    ,o.upd_opr_id -- 修改记录操作员
    ,o.crt_opr_id -- 创建记录操作员
    ,o.rec_upd_ts -- 记录修改时间
    ,o.rec_crt_ts -- 记录创建时间
    ,o.install_tel -- 装机人电话
    ,o.mcht_grade -- 商户评级 计算评分
    ,o.reserved1 -- 商户评级信息
    ,o.reserved2 -- 保留字段
    ,o.integral_method -- 积分累计方式
    ,o.integral_rate -- 消费积分比率
    ,o.integral_fee_limit -- 累计积分限额
    ,o.integral_number -- 按笔累计积分
    ,o.acct_flag -- 暂缓入账标识
    ,o.is_auto_check_level -- 是否自动评级
    ,o.level1 -- 
    ,o.level2 -- 
    ,o.level3 -- 
    ,o.level4 -- 
    ,o.level5 -- 
    ,o.mcht_sync_status -- 
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
from ${iol_schema}.mrms_tbl_mcht_base_inf_bk o
    left join ${iol_schema}.mrms_tbl_mcht_base_inf_op n
        on
            o.mcht_no = n.mcht_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mrms_tbl_mcht_base_inf_cl d
        on
            o.mcht_no = d.mcht_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mrms_tbl_mcht_base_inf;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mrms_tbl_mcht_base_inf') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mrms_tbl_mcht_base_inf drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mrms_tbl_mcht_base_inf add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mrms_tbl_mcht_base_inf exchange partition p_${batch_date} with table ${iol_schema}.mrms_tbl_mcht_base_inf_cl;
alter table ${iol_schema}.mrms_tbl_mcht_base_inf exchange partition p_20991231 with table ${iol_schema}.mrms_tbl_mcht_base_inf_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mrms_tbl_mcht_base_inf to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_mcht_base_inf_op purge;
drop table ${iol_schema}.mrms_tbl_mcht_base_inf_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mrms_tbl_mcht_base_inf_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mrms_tbl_mcht_base_inf',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
